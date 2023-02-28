package com.marroticket.umember.member.controller;

import com.marroticket.common.email.domain.EmailVO;
import com.marroticket.common.email.service.EmailService;

import java.security.SecureRandom;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.marroticket.umember.member.domain.UmemberVO;
import com.marroticket.umember.member.service.UmemberService;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.play.service.PlayService;
import com.marroticket.umember.reservation.domain.ReservationVO;
import com.marroticket.umember.reservation.service.ReservationService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/umember")
@Slf4j
public class UmemberController {
	@Autowired
	private UmemberService umemberService;
	@Autowired
	private ReservationService reservationService;
	@Autowired
	private PlayService playService;
	@Autowired
	private EmailService emailService;
	@Autowired
	private PasswordEncoder passwordEncoder;

// 아이디 찾기
	@PostMapping("/findId")
	public ResponseEntity<String> findId(@RequestBody UmemberVO umember) throws Exception {
		System.out.println("아이디 찾기 메서드 호출");

		// 값이 정상적으로 입력됐을 때, db조회
		String uId = umemberService.findId(umember);

		System.out.println("아이디 찾기 : " + umember);

		// 응답
		if (uId != null && uId.length() > 0) {
			return new ResponseEntity<String>(uId, HttpStatus.OK);
		} else {
			return new ResponseEntity<String>("fail", HttpStatus.OK);
		}
	}

	// 비밀번호 찾기 - 임시비밀번호 업데이트
	@PostMapping("/findPassword")
	public ResponseEntity<String> findPassword(@RequestBody UmemberVO umember) throws Exception {
		ResponseEntity<String> entity;

		// 임시비밀번호 생성(15자리)
		String temporaryPassword = getRamdomPassword(15);

		// 비밀번호 암호화
		umember.setUPassword(passwordEncoder.encode(temporaryPassword));

		System.out.println("비밀번호 찾기 : " + umember);

		// 임시비밀번호로 업데이트 : 업데이트는 where조건(id, email이 db데이터 조회 시, 부합)에 따라 성공/실패
		int success = umemberService.passwordUpdate(umember);

		if (success != 0) { // 업데이트 성공
			temporaryPasswordSendEmail(temporaryPassword, umember.getuEmail()); // 임시비밀번호 발송
			entity = new ResponseEntity<String>("send", HttpStatus.OK);
			// 임시비밀번호 이메일 발송
		} else { // 업데이트 실패
			entity = new ResponseEntity<String>("fail", HttpStatus.OK);
		}
		return entity;
	}

	// 마이페이지
	/* 1) 일반 회원 정보 */
	@GetMapping("/umembermypage")
	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	public String myPage(Model model) throws Exception {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("마이페이지 정보 조회 호출");
		String uId = authentication.getName();

		// 서비스에서 아이디로 정보 불러오기
		UmemberVO vo = umemberService.getUmemberByUId(uId);

		System.out.println(vo.getUmemberAuthList().get(0).getUNumber());

		// 성별 표시
		if (vo.getuGender().equals("1")) {
			vo.setuGender("남자");
		} else {
			vo.setuGender("여자");
		}
		// 장르표시
		switch (vo.getuGenre()) {
		case "1":
			vo.setuGenre("로맨스");
			break;
		case "2":
			vo.setuGenre("코미디");
			break;
		case "3":
			vo.setuGenre("드라마");
			break;
		case "4":
			vo.setuGenre("공포");
			break;
		case "5":
			vo.setuGenre("추리/스릴러");
			break;
		case "6":
			vo.setuGenre("판타지");
			break;
		case "7":
			vo.setuGenre("시대/역사");
			break;
		}
		model.addAttribute("vo", vo);

		return "mypage.umemberInfo"; // 일반 회원의 마이페이지 default 페이지
	}

	// 회원정보 수정 페이지
	@RequestMapping(value = "/umemberModify", method = RequestMethod.GET)
	public String getMyPage(Model model) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();

		// 서비스에서 아이디로 정보 불러오기
		UmemberVO vo = umemberService.getUmemberByUId(uId);

		// 성별 표시
		if (vo.getuGender().equals("1")) {
			vo.setuGender("남자");
		} else {
			vo.setuGender("여자");
		}
		model.addAttribute("vo", vo);
		return "mypage.umemberModify";
	}

	@RequestMapping(value = "/umemberModify", method = RequestMethod.POST)
	public String updateMyPage(@ModelAttribute("vo") UmemberVO vo, HttpServletRequest request,
			@RequestParam("uPassword") String uPassword, @RequestParam("changePw") String changePw,
			@RequestParam("confirmPw") String confirmPw, RedirectAttributes rttr) throws Exception {
		System.out.println("수정 호출");

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();

		// 비밀번호 암호화
		String inputPassword = uPassword;
		vo.setUPassword(passwordEncoder.encode(inputPassword));

		UmemberVO originalVO = umemberService.getUmemberByUId(uId);

		// 1. 로그인한 비밀번호 확인
		if (!passwordEncoder.matches(inputPassword, originalVO.getUPassword())) {
			System.out.println("에러 : 기존 비밀번호에 입력된 값이 없거나 틀린 비밀번호 입니다.");
			rttr.addFlashAttribute("msg", "에러 : 기존 비밀번호에 입력된 값이 없거나 틀린 비밀번호 입니다.");
			return "redirect:/umember/umemberModify";
		}

		// 2. 변경할 비밀번호와 로그인한 비밀번호가 일치하면 오류
		if (passwordEncoder.matches(changePw, originalVO.getUPassword())) {
			System.out.println("에러 : 기존 비밀번호와 같은 비밀번호를 사용 할 수 없습니다.");
			rttr.addFlashAttribute("emsg", "에러 : 기존 비밀번호와 같은 비밀번호를 사용 할 수 없습니다.");
			return "redirect:/umember/umemberModify";
		}

		// 성별 값
		if (vo.getuGender().equals("1")) {
			vo.setuGender("남자");
		} else {
			vo.setuGender("여자");
		}

		// 기존 비밀번호랑도 다르면
		if (!changePw.isEmpty() && !changePw.equals(inputPassword)) {
			// 변경한 비밀번호도 암호화
			vo.setUPassword(passwordEncoder.encode(changePw));
			// 비밀번호 변경시 로그아웃
			HttpSession session = request.getSession(false);
			if (session != null) {
				session.invalidate();
			}
		}
		umemberService.modify(vo);

		// 업데이트된 사용자 정보 가져오기
		UmemberVO updatedVO = umemberService.getUmemberByUId(uId);

		// 비밀번호 변경 없이 다른 정보들을 수정할 경우 마이페이지상태로 돌아감
		return "redirect:/umember/umembermypage";

	}

	// 회원탈퇴
	@RequestMapping(value = "/umemberSecession", method = RequestMethod.GET)
	public String secession(Model model) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();

		model.addAttribute("uId", uId);

		return "mypage.umemberSecession";
	}

	@RequestMapping(value = "/umemberSecession", method = RequestMethod.POST)
	public String deleteSecession(@ModelAttribute("umemberVo") UmemberVO umemberVo,
			@RequestParam("uPassword") String uPassword, Model model, HttpSession session) throws Exception {
		System.out.println("탈퇴 페이지 호출");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();
		UmemberVO originalVO = umemberService.getUmemberByUId(uId);

		if (!passwordEncoder.matches(uPassword, originalVO.getUPassword())) {
			System.out.println("비밀번호 틀림");
			model.addAttribute("passwordError", "에러메시지");
			return "mypage.umemberSecession";
		}
		umemberService.remove(originalVO);
		session.invalidate();
		return "redirect:/";
	}

	/* 일반회원 예매 정보 */
//    String ex = "2023-02-09";
//    System.out.println(ex.substring(0,4));

	@GetMapping("/umemberReserveInfo")
	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	public String reservation(Model model) throws Exception {
		System.out.println("예약 정보 호출");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();
		UmemberVO vo = umemberService.getUmemberByUId(uId);

		int uNumber = vo.getuNumber();
		List<ReservationVO> reservationList = reservationService.getReservationListByUNumber(uNumber);
		System.out.println(reservationList);
		model.addAttribute("reservationList", reservationList);

		return "mypage.umemberReservationList";
	}

	/** 예 매 취 소 **/
	@GetMapping("/cancelReservation/{rnumber}")
	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	public String cancelReservation(@PathVariable Integer rnumber) throws Exception {
		System.out.println("취소 호출");
		System.out.println("rnumber : " + rnumber);
		reservationService.cancelReservation(rnumber);
		return "redirect:/umember/umemberCancelInfo";
	}

	/* 일반 회원 예매 취소 정보 */
	@GetMapping("/umemberCancelInfo")
	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	public String umemberCancelInfo(Model model) throws Exception {
		System.out.println("예매 취소 정보 호출");

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();
		UmemberVO vo = umemberService.getUmemberByUId(uId);

		int uNumber = vo.getuNumber();
		List<ReservationVO> reservationList = reservationService.getReservationListByUNumber(uNumber);
		System.out.println(reservationList);
		model.addAttribute("reservationList", reservationList);

		return "mypage.umemberCancelInfo";
	}

	// 일반 회원 나의 관람 연극 내역
	@GetMapping("/umemberViewHistory")
	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	public String umemberViewHistory(Model model) throws Exception {
		System.out.println("관람한 연극 내역 호출");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();
		UmemberVO vo = umemberService.getUmemberByUId(uId);

		int uNumber = vo.getuNumber();
		ReservationVO reservation = new ReservationVO();
		reservation.setRcancelDeadline(new Date());
		List<ReservationVO> reservationList = reservationService.viewingHistory(uNumber);
		System.out.println(reservationList);
		model.addAttribute("reservationList", reservationList);

		return "mypage.umemberViewHistory";
	}

	// 일반 회원 나의 맞춤 연극 리스트
	@GetMapping("/umemberCustomPlayList")
	@PreAuthorize("hasRole('ROLE_UMEMBER')")
	public String umemberCustomPlayList(Model model) throws Exception {
		System.out.println("맞춤 연극 호출");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String uId = authentication.getName();
		UmemberVO umemberVO = umemberService.getUmemberByUId(uId);

		List<PlayVO> playList = playService.playCurrentList();
		playList.addAll(playService.playExpectedList());

		System.out.println(playList);

		// 사용자가 선호하는 장르에 따라 목록 필터링
		List<PlayVO> filteredPlayList = playList.stream().filter(play -> play.getPgenre().equals(umemberVO.getuGenre()))
				.sorted(Comparator.comparing(PlayVO::getPfirstStartTime)).collect(Collectors.toList());

		model.addAttribute("playList", filteredPlayList);
		model.addAttribute("uName", umemberVO.getuName());
		model.addAttribute("uGenre", GenreName(umemberVO.getuGenre()));

		return "mypage.umemberCustomPlayList";
	}

	private String GenreName(String genreCode) {
		switch (genreCode) {
		case "1":
			return "로맨스";
		case "2":
			return "코미디";
		case "3":
			return "드라마";
		case "4":
			return "공포";
		case "5":
			return "추리/스릴러";
		case "6":
			return "판타지";
		case "7":
			return "시대/역사";
		default:
			return "";
		}
	}

	// 일반회원 가입 이용약관
	@GetMapping("/umemberAgreement")
	public String umemberAgreement() {
		System.out.println("umemberAgreement 호출 완료");
		return "uMemberJoin.umemberAgreement";
	}

	// 일반 회원가입 페이지
	@GetMapping("/umemberJoinForm")
	public String umemberJoinForm(@ModelAttribute("umember") UmemberVO umember) {
		System.out.println("umemberJoinForm 호출 완료");
		return "uMemberJoin.umemberJoinForm";
	}

	// 아이디 중복 체크
	@ResponseBody
	@PostMapping("/uIdCheck")
	public ResponseEntity<String> uIdCheck(UmemberVO umember) throws Exception {
		System.out.println("중복 아이디 체크 컨트롤러 불러옴\numember : " + umember.toString());
		int result = umemberService.uIdCheck(umember);
		ResponseEntity<String> entity = null;
		System.out.println(result);
		if (result == 1) {
			entity = new ResponseEntity<>("overlap", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<>("no overlap", HttpStatus.OK);
		}
		return entity;
	}

	// 회원가입 등록
	@PostMapping("/register")
	public String register(@ModelAttribute("umember") @Validated UmemberVO umember, BindingResult result)
			throws Exception {
		log.info("register호출");
		// 회원 가입 실패시 리스트로 나열
		if (result.hasErrors()) {
			List<ObjectError> list = result.getAllErrors();
			for (ObjectError error : list) {
				System.out.println(error);
			}
			return "uMemberJoin.umemberJoinForm";
		}

		// 비밀번호 암호화
		String inputPassword = umember.getUPassword();
		umember.setUPassword(passwordEncoder.encode(inputPassword));

		// 등록 service 호출
		umemberService.register(umember);
		System.out.println("등록 성공" + umember.toString());

		return "uMemberJoin.umemberJoinSuccess";
	}

	// 회원가입 성공 페이지
	@GetMapping("/umemberJoinSuccess")
	public String umemberJoinSuccess() {
		System.out.println("umemberJoinSuccess 호출 완료");
		return "uMemberJoin.umemberJoinSuccess";
	}

	// 랜덤한 임시비밀번호 생성
	public String getRamdomPassword(int size) {
		char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
				'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a',
				'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
				'w', 'x', 'y', 'z', '!', '@', '#', '$', '%', '^', '&' };

		StringBuffer sb = new StringBuffer();
		SecureRandom sr = new SecureRandom();
		sr.setSeed(new Date().getTime());

		int idx = 0;
		int len = charSet.length;
		for (int i = 0; i < size; i++) {
			// idx = (int) (len * Math.random());
			idx = sr.nextInt(len); // 강력한 난수를 발생시키기 위해 SecureRandom을 사용한다.
			sb.append(charSet[idx]);
		}

		return sb.toString();
	}

	// 임시비밀번호 이메일 발송
	public void temporaryPasswordSendEmail(String temporaryPassword, String uEmail) throws Exception {
		String title = "마로티켓입니다. 임시비밀번호를 확인해주세요"; // 이메일 제목
		// set
		EmailVO email = new EmailVO(); // 이메일 객체
		email.setAddress(uEmail);
		email.setTitle(title);
		email.setPassword(temporaryPassword);

		// 이메일 발송
		emailService.sendUmemberEmail(email);
		// console 확인
		System.out.println("findPasswordSendEmail 임시이메일 발송 완료");
	}
}
