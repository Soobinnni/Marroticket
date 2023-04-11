package com.marroticket.umember.reservation.controller;

import java.lang.reflect.Field;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.Gson;
import com.marroticket.umember.member.domain.UmemberVO;
import com.marroticket.umember.member.service.UmemberService;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.umember.reservation.domain.ReservationVO;
import com.marroticket.umember.reservation.domain.SeatVO;
import com.marroticket.umember.reservation.service.ReservationService;

@Controller
@RequestMapping("/reserve")
public class ReservationController {

	@Autowired
	private ReservationService reserveService;
	@Autowired
	private UmemberService umemberService;

	// 공연 회차 정보
	@PostMapping("/schedule")
	public ResponseEntity<Map<String, Integer>> schedule(@RequestBody PlayVO vo, String date) throws Exception {
		System.out.println(vo.toString());

		System.out.println("예매일 : " + date);

		List<SeatVO> firstPlayReserveList = null;// 1회차 List
		List<SeatVO> secondPlayReserveList = null;// 2회차 List
		Map<String, Integer> remainSeat = new HashMap<>();
		int countfirstPlayReserve = 0; // 예약된 1회차 좌석 개수
		int countSecondPlayReserve = 0; // 예약된 2회차 좌석 개수

		// 1회차 잔여 좌석 count
		firstPlayReserveList = getReserveList(getTicketNum(date, vo.getPnumber(), 1, ""));
		if (firstPlayReserveList == null) {
			countfirstPlayReserve = 0;
		} else {
			countfirstPlayReserve = countReserveSeatNum(firstPlayReserveList);
			System.out.println("예약된 좌석수 1회차 : " + countfirstPlayReserve);
		}

		// 2회차 잔여 좌석 count
		if (vo.getPsecondStartTime().equals("없음")) {
			remainSeat.put("first", Integer.parseInt(vo.getPseatNumber()) - countfirstPlayReserve);
			remainSeat.put("second", 100);
			return new ResponseEntity<>(remainSeat, HttpStatus.OK);
		} else {
			secondPlayReserveList = getReserveList(getTicketNum(date, vo.getPnumber(), 2, ""));
			if (secondPlayReserveList == null) {
				countSecondPlayReserve = 0;
			} else {
				countSecondPlayReserve = countReserveSeatNum(secondPlayReserveList);
				System.out.println("예약된 좌석수 2회차 : " + countSecondPlayReserve);
			}
		}

		// Map에 담기
		remainSeat.put("first", Integer.parseInt(vo.getPseatNumber()) - countfirstPlayReserve);
		remainSeat.put("second", Integer.parseInt(vo.getPseatNumber()) - countSecondPlayReserve);

		ResponseEntity<Map<String, Integer>> entity = new ResponseEntity<>(remainSeat, HttpStatus.OK);

		return entity;
	}
	
	//마로티켓 봇 기능
	@PostMapping("/recommendSeat")
	public ResponseEntity<List<String>> recommendSeat(@RequestBody ReservationVO vo) throws Exception {
		System.out.println(vo);
		List<SeatVO> playReserveList =  getReserveList(getTicketNum(vo.getPdate(), vo.getPnumber(),vo.getPturn(),""));;// 공연 예매된 티켓번호 List
		List<String> playReserveSeatsNumList = new ArrayList<>();// 좌석번호 List
		List<String> playSeatNumList = getSeatNum(Integer.parseInt(vo.getPseatNumber()), 9); //전체 좌석번호
		
		for (String reserveSeat : getReserveSeats(playReserveList)) {
			reserveSeat = reserveSeat.substring((reserveSeat.length() - 2), reserveSeat.length());
			playReserveSeatsNumList.add(reserveSeat);
		}

		//예매 좌석을 제외한 좌석 	
		playSeatNumList.removeAll(playReserveSeatsNumList);  // 겹치는 요소만 남기고 삭제
		System.out.println("예매된 좌석을 제외한 잔여 좌석\n"+playSeatNumList); 
		
		ResponseEntity<List<String>> entity = new ResponseEntity<>(playSeatNumList, HttpStatus.OK);
		return entity;
	}
	
	@PostMapping("/remainSeatsNumSuggestion")
	public String remainSeatsNumSuggestion(String pdate, String pnum, String pturn) {
		return null;
	}

	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	@PostMapping("/book")
	public String book(ReservationVO vo, Model model, Principal principal, HttpServletRequest request)
			throws Exception {
		// 사용자 정보 GET / SET
		UmemberVO member = umemberService.getUmemberByUId(principal.getName());
		vo.setUnumber(member.getuNumber());
		vo.setUid(member.getuId());
		vo.setUname(member.getuName());
		vo.setUphonenumber(member.getuPhoneNumber());
		vo.setUemail(member.getuEmail());

		// 임시 예매자의 세션 생성(소멸 시기 : 예약 확정자로 변환될 때)
		System.out.println("임시 예매자 세션 생성");
		HttpSession session = request.getSession(true);
		session.setAttribute("preReserved", vo);

		// 예매 티켓 확인 및 결제 전까지의 좌석 선점 유효 시간이 지난 좌석 소멸 작업 start
		List<SeatVO> playReserveList = null;// 공연 예매된 티켓번호 List
		List<String> playReserveSeatsNumList = new ArrayList<>();// 좌석번호 List

		String ticketNumWithoutSeatInfo = getTicketNum(vo.getPdate(), vo.getPnumber(), vo.getPturn(), "");
		playReserveList = getReserveList(ticketNumWithoutSeatInfo);

		int check = deleteDataBeforeTime(vo, ticketNumWithoutSeatInfo);
		System.out.println("n분이 지나 삭제된 예매진행중 좌석 수 : " + check);

		for (String reserveSeat : getReserveSeats(playReserveList)) {
			reserveSeat = reserveSeat.substring((reserveSeat.length() - 2), reserveSeat.length());
			playReserveSeatsNumList.add(reserveSeat);
		}
		System.out.println("예약된 좌석번호 확인 : " + playReserveSeatsNumList); // 좌석번호 확인
		// end

		// view
		model.addAttribute("reservation", vo);
		model.addAttribute("reserveSeat", new Gson().toJson(playReserveSeatsNumList)); // 직렬화하지 않은 데이터를 jquery가 인식하지 못해서
																						// parse

		// return
		return "reserve.1.selectSeat";
	}

	// 구매 전 확인 및 결제(아직 구매 전 사용자)
	@PostMapping("/confirmReserve")
	public String confirmReserve(ReservationVO ticketInfoVO, HttpSession session, Model model) throws Exception {
		ReservationVO vo = (ReservationVO) session.getAttribute("preReserved");

		// 선택한 예매 정보 set
		vo.setRtotalpayment(ticketInfoVO.getRtotalpayment());
		vo.setRticketcount(ticketInfoVO.getRticketcount());
		vo.setRticketFirst(ticketInfoVO.getRticketFirst());
		vo.setRticketSecond(ticketInfoVO.getRticketSecond());
		vo.setRticketThird(ticketInfoVO.getRticketThird());
		vo.setRticketFourth(ticketInfoVO.getRticketFourth());

		System.out.println("confirmReserve의 정보 : " + vo);

		// 새 정보로 set
		session.setAttribute("preReserved", vo);

		// view
		model.addAttribute("reservation", vo);

		// return
		return "reserve.2.confirmReserve";
	}

	// 결제 완료.
	@PostMapping("/completeReserve")
	public ResponseEntity<String> completeReserve(HttpSession session, Model model) throws Exception {
		// 구매 확정자의 이선좌 내역을 지운다.
		ReservationVO vo = (ReservationVO) session.getAttribute("preReserved");
		int check = deleteHistory(vo);
		System.out.println("이선좌의 내역은 지운다. 개수 : " + check);

		// 최종적인 결제를 insert & insert vo select(==reserveVO)
		ReservationVO reserveVO = reserveService.register(vo);

		// 구매 전 예매상태 session 소멸시키고 구매 확정상태의 session 생성
		session.removeAttribute("preReserved");
		session.setAttribute("reserved", reserveVO);
		System.out.println("예매 확정 : " + reserveVO);

		// return
		return new ResponseEntity<>("complete", HttpStatus.OK);
	}

	// 구매 세부 내역
	@PostMapping("/reservationDetails")
	public String reservationDetails(HttpSession session, Model model) throws Exception {
		// 구매 확정자의 ReservationVO
		ReservationVO reservedVO = (ReservationVO) session.getAttribute("reserved");
		switch (reservedVO.getRticketFirst().substring(reservedVO.getRticketFirst().length() - 3,
				reservedVO.getRticketFirst().length() - 2)) { // 회차 set
		case "1":
			reservedVO.setPturn(1);
			reservedVO.setPsecondStartTime(null);
			break;
		case "2":
			reservedVO.setPturn(2);
			reservedVO.setPfirstStartTime(null);
			break;
		}

		// view
		model.addAttribute("reservation", reservedVO);

		// return
		return "reserveDetails";
	}

	// 선택한 좌석이 이미 선점한 사용자가 있는지 check
	@PostMapping("/checkSeatAvailability")
	public ResponseEntity<Boolean> checkSeatAvailability(@RequestBody ReservationVO vo) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();

		// 이선좌 확인
		boolean isReserved = isSeatReserved(vo); // 예매가 가능하면 false를 예매 불가능하면 true를 반환

		if (!isReserved) { // 예매가능 : 예매가능 유효시각을(현재 시각으로부터 6분 뒤) db에 저장 && 예매상태를 1로 전환
			Instant instant = Instant.now().plus(6, ChronoUnit.MINUTES);
			Date date = Date.from(instant);

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMddHHmm");
			String formattedDate = dateFormat.format(date.getTime());

			long reservationHoldingTime = Long.parseLong(formattedDate);

			// parameter put
			paramMap.put("reservationHoldingTime", reservationHoldingTime);
			paramMap.put("reservation", vo);
			// query 결과
			int check = reserveService.advanceReserve(paramMap);
			System.out.println("이선좌 성공 : " + check);
		}

		// return
		return new ResponseEntity<Boolean>(isReserved, HttpStatus.OK);
	}

	// 사용자의 좌석 체크 해제로 인한 이선좌 취소
	@PostMapping("/uncheckSeat")
	public ResponseEntity<String> uncheckSeat(@RequestBody ReservationVO vo) throws Exception {
		// 이선좌 취소
		int check = reserveService.delete(vo);
		System.out.println("사용자의 좌석 체크 해제로 인한 이선좌 취소 완료 : " + check);
		return new ResponseEntity<String>("unchecked complete", HttpStatus.OK);
	}

	// 사용자의 새로고침 or 페이지 들어왔다 나감으로 인한 이선좌 취소
	@PostMapping("/selectSeatRefresh")
	public ResponseEntity<String> selectSeatRefresh(@RequestBody ReservationVO vo) throws Exception {
		int check = deleteHistory(vo);
		System.out.println("새로고침 또는 새로 들어옴으로써 deleteHistory 완료 : " + check);
		return new ResponseEntity<String>("deleteHistory complete", HttpStatus.OK);
	}

	private int deleteHistory(ReservationVO vo) throws Exception {
		return reserveService.deleteHistory(vo);
	}

	private boolean isSeatReserved(ReservationVO vo) throws Exception {
		System.out.println("비교하는 티켓번호 : " + vo.getRticketFirst());
		// 이선좌 list를 불러오는 reserveService -> reservingList();
		if (countReserveSeatNum(reserveService.reservinglist(vo.getRticketFirst())) == 0) {
			System.out.println("예매가능");
			return false;
		} else {
			System.out.println("예매불가능");
			return true;
		}
	}

	private int deleteDataBeforeTime(ReservationVO vo, String ticketNumWithoutSeatInfo) throws Exception { // 예매진행중 상태에서
																											// 6분이 지나면,
																											// 예매상태를
																											// 변경한다.(삭제)
		Map<String, Object> map = new HashMap<>();

		// 현재시각 parse long
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMddHHmm");
		Date date = new Date();
		String formattedDate = dateFormat.format(date);
		long currentTime = Long.parseLong(formattedDate);

		map.put("reservation", vo);
		map.put("currentTime", currentTime);
		map.put("ticketNum", ticketNumWithoutSeatInfo);

		// 예매진행 중인 상태에서 6분이 지났으면 삭제
		int check = reserveService.deleteDataAfterTime(map);
		return check;
	}

	// 티켓번호 생성
	private String getTicketNum(String playDate, int pnumber, int turn, String seatInfo) {
		// 티켓번호 == yyyymmdd + p_number + 회차 + 좌석정보(ex-(min)a1, a2, ... , (max)p6 )
		return playDate + pnumber + turn + seatInfo;
	}

	// 예매 리스트 생성
	private List<SeatVO> getReserveList(String ticketNum) throws Exception {
		List<SeatVO> reserveList = reserveService.list(ticketNum);
		return reserveList;
	}
	
	// 좌석 번호 생성
	private List<String> getSeatNum(int numSeats, int numColumns) { //좌석 수, 열 개수
		List<String> seatNums = new ArrayList<>();
		
		for (int i = 1; i <= numSeats; i++) {
		    int row = (i - 1) / numColumns + 1;
		    int col = (i - 1) % numColumns + 1;
		    char seatRow = (char) ('a' + row - 1);
		    String seatNum = String.format("%c%d", seatRow, col);
		    seatNums.add(seatNum);
		}
		return seatNums;
	}

	// 예매 좌석 카운트
	private int countReserveSeatNum(List<SeatVO> seats) {
		int count = 0;
		for (Object obj : seats) {
			for (Field field : obj.getClass().getDeclaredFields()) {
				field.setAccessible(true);
				try {
					if (field.getType() == String.class) {
						String value = (String) field.get(obj);
						if (value != null && !value.equals("0")) { // 티켓번호가 null이거나 0인 컬럼은 세지 않는다.
							count++;
						}
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		}
		return count;
	}

	// 예매 티켓번호 반환
	private List<String> getReserveSeats(List<SeatVO> seats) {
		List<String> nonZeroStrings = new ArrayList<>();
		for (Object obj : seats) {
			for (Field field : obj.getClass().getDeclaredFields()) {
				field.setAccessible(true);
				try {
					if (field.getType() == String.class) {
						String value = (String) field.get(obj);
						if (value != null && !value.equals("0")) { // 티켓번호가 null이거나 0인 컬럼은 가져오지 않는다.
							nonZeroStrings.add(value);
						}
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		}
		return nonZeroStrings;
	}
}