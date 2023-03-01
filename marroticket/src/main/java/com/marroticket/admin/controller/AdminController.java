package com.marroticket.admin.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.marroticket.admin.payment.domain.PaymentVO;
import com.marroticket.admin.payment.service.PaymentService;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.common.domain.Pagination;
import com.marroticket.tmember.member.domain.TmemberVO;
import com.marroticket.tmember.member.service.TmemberService;
import com.marroticket.umember.member.service.UmemberService;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.play.service.PlayService;
import com.marroticket.umember.reservation.domain.ReservationVO;

import lombok.extern.java.Log;

@PreAuthorize("hasRole('ROLE_ADMIN')")
@Log
@Controller
@RequestMapping("/admin")
@MapperScan(basePackages = "com.marroticket.mapper")
public class AdminController {

	@Autowired
	PaymentService paymentService;

	@Value("${upload.path}")
	private String uploadPath;

	@Value("${file.dir}") // 맥용으로 설정했으니 윈도우일땐 프로퍼티에서 설정 바꾸기
	private String uploadDir;

	// 관리자 로그인시 관리자 메인 페이지로 전환
	@GetMapping("")
	public String admin() {
		return "admin";
	}

	@Autowired
	private PlayService playService;

	@Autowired
	private UmemberService umemberService;

	@Autowired
	private TmemberService tmemberService;

	// 정산관리목록 출력
	@GetMapping("/paymentList")
	public String list(PageRequest pageRequest, Model model) throws Exception {

		// 뷰에 페이징 처리를 한 게시글 목록을 전달한다.
		String url = "payment/paymentList";

		List<PaymentVO> paymentVOList;
		paymentVOList = paymentService.payment(pageRequest);
		model.addAttribute("paymentList", paymentVOList);

		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(paymentService.count());
		model.addAttribute("pagination", pagination);
		// }

		return url;
	}

	// 정산 하기 버튼
	@ResponseBody
	@PostMapping("/payment")
	public String payment(int pNumber) throws Exception {

		System.out.println(pNumber);
		String url = "payment/paymentAuthorization";

		PaymentVO payment = new PaymentVO();

		PlayVO play = paymentService.play(pNumber);

		List<ReservationVO> reservationList = paymentService.reservationList(pNumber);

		// 지급 일자 설정
		Calendar closeDay = Calendar.getInstance();
		closeDay.setTime(play.getPcloseDate());
		closeDay.add(Calendar.MONTH, 1);
		closeDay.set(Calendar.DATE, 20);
		payment.setPayPayDate(closeDay.getTime());

		// 총 정산금액 설정
		int totalPay = 0;// 총 정산금액
		for (ReservationVO reservationVO : reservationList) {
			if (reservationVO.getRcancelState() == 0) {
				totalPay += reservationVO.getRtotalpayment();
			} else if (reservationVO.getRcancelState() == 1) {
				totalPay += reservationVO.getRfee() * reservationVO.getRticketcount();
			}
		}
		payment.setPayPayment(totalPay);

		// 극단 정산금액 설정
		int theaterPay = 0;// 극단 정산금액
		for (ReservationVO reservationVO : reservationList) {

			if (reservationVO.getRcancelState() == 0) {
				theaterPay += reservationVO.getRtotalpayment();
				theaterPay = theaterPay - reservationVO.getRfee() * reservationVO.getRticketcount();
			}
		}
		payment.setPayTheaterPayment(theaterPay);

		// 사이트 정산금액 설정
		int sitePay = 0; // 사이트 정산금액
		for (ReservationVO reservationVO : reservationList) {
			sitePay += reservationVO.getRfee() * reservationVO.getRticketcount();
		}
		payment.setPaySitePayment(sitePay);

		// 연극 번호 설정
		payment.setPNumber(pNumber);

		paymentService.paymentcreate(payment);

		return url;
	}

	// 정산 내역
	@GetMapping("/paymentAuthorization")
	public String history(Model model, int pNumber) throws Exception {
		String url = "payment/paymentAuthorization";

		PaymentVO paymentHistory;
		paymentHistory = paymentService.paymentHistory(pNumber);
		model.addAttribute("paymentHistory", paymentHistory);

		return url;
	}

	// 극단 목록
	@RequestMapping(value = "/tmemberApproveList", method = RequestMethod.GET)
	public String tmemberList(@ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		List<TmemberVO> tmemberList = new ArrayList<>();
		tmemberList = tmemberService.list(pageRequest);
		model.addAttribute("tmemberList", tmemberList);
		log.info(tmemberList.toString());

		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(tmemberService.count());
		model.addAttribute("pagination", pagination);
		return "member/tmemberApproveList";
	}

	// 사업자등록증 표시
	@ResponseBody
	@RequestMapping("/tmemberBusinessRegistration")
	public ResponseEntity<byte[]> ImageFile(Integer TNumber) throws Exception {

		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		String fileName = tmemberService.BusinessRegistration(TNumber);

		try {
			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
			MediaType mType = getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(uploadDir + File.separator + fileName);
			if (mType != null) {
				headers.setContentType(mType);
			}
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}
		return entity;
	}

	// 극단 회원 승인 처리 페이지
	@RequestMapping(value = "/tmemberApprove", method = RequestMethod.GET)
	public String tmemberApprove(TmemberVO tmemberVO, RedirectAttributes rttr) throws Exception {

		tmemberService.tmemberApprove(tmemberVO); // 극단 회원 승인 처리를 위한 서비스
		tmemberService.tmemberAuthUpgrade(tmemberVO); // 극단 회원 권한 업그레이드 서비스

		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("승인처리");

		return "redirect:/admin/tmemberApproveList";
	}

	// 극단 회원 계약만료 처리 페이지
	@RequestMapping(value = "/tmemberExpiration", method = RequestMethod.GET)
	public String tmemberExpiration(TmemberVO tmemberVO, RedirectAttributes rttr) throws Exception {

		tmemberService.tmemberExpiration(tmemberVO); // RedirectAttributes 객체에 일회성 데이터를 지정하여전달한다.
		tmemberService.tmemberAuthDowngrade(tmemberVO); // 계약만료에 따른 극단 회원 권한 다운그레이드 서비스

		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("계약만료처리");

		return "redirect:/admin/tmemberApproveList";
	}

	// 연극 목록
	@RequestMapping(value = "/playApproveList", method = RequestMethod.GET)
	public void playApproveList(@ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		// log.info(model.toString());

		model.addAttribute("playApproveList", playService.playApproveList(pageRequest));

		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(playService.count());
		model.addAttribute("pagination", pagination);

	}

	// 연극 상세보기
	@RequestMapping(value = "/playDetail", method = RequestMethod.GET)
	public String playDetail(int pnumber, Model model) throws Exception {
		model.addAttribute(playService.playDetail(pnumber));
		return "admin/playDetail";
	}

	// 연극 승인
	@RequestMapping(value = "/playApprove", method = RequestMethod.GET)
	public String playApprove(String pnumber, PlayVO playVO, RedirectAttributes rttr) throws Exception {

		playService.playApprove(playVO);
		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("승인처리");

		return "redirect:/admin/playApproveList";
	}

	// 연극 반려
	@RequestMapping(value = "/playReject", method = RequestMethod.GET)
	public String playReject(String pnumber, PlayVO playVO, RedirectAttributes rttr) throws Exception {

		playService.playReject(playVO);
		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("반려처리");

		return "redirect:/admin/playApproveList";
	}

	// 수정 연극 목록
	@RequestMapping(value = "/playModifyList", method = RequestMethod.GET)
	public void playModifyList(@ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		// log.info(model.toString());
		model.addAttribute("playModifyList", playService.playModifyList(pageRequest));

		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(playService.modifyCount());
		model.addAttribute("pagination", pagination);
	}

	// 연극 수정 임시등록
	@RequestMapping(value = "/playModify", method = RequestMethod.GET)
	public String playModify(String pnumber, PlayVO playVO, RedirectAttributes rttr) throws Exception {

		playService.playModify(playVO);
		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("승인처리");

		return "redirect:/admin/playModifyList";
	}

	// 상연 예정 페이지
	@GetMapping("/playExpectedList")
	public String playExpectedList(Model model) throws Exception {

		List<PlayVO> playExpectedList = new ArrayList<>();
		playExpectedList = playService.playExpectedList();

		model.addAttribute("playExpectedList", playExpectedList);

		return "play/playExpectedList";

	}

	// 현재 상연 페이지
	@GetMapping("/playCurrentList")
	public String playCurrentList(Model model) throws Exception {

		List<PlayVO> playCurrentList = new ArrayList<>();
		playCurrentList = playService.playCurrentList();
		model.addAttribute("playCurrentList", playCurrentList);

		return "play/playCurrentList";
	}

	// 지난 상연 페이지
	@GetMapping("/playPassList")
	public String playPassList(Model model) throws Exception {

		List<PlayVO> playPassList = new ArrayList<>();
		playPassList = playService.playPassList();
		model.addAttribute("playPassList", playPassList);

		return "play/playPassList";
	}

	// 포스터 표시
	@ResponseBody
	@RequestMapping("/poster")
	public ResponseEntity<byte[]> pictureFile(Integer pnumber) throws Exception {
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		String fileName = playService.getPposter(pnumber);
		try {
			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
			MediaType mType = getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(uploadPath + File.separator + fileName);
			if (mType != null) {
				headers.setContentType(mType);
			}
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}
		return entity;
	}

	// 파일 확장자로 이미지 형식 확인
	private MediaType getMediaType(String formatName) {
		if (formatName != null) {
			if (formatName.equals("JPG")) {
				return MediaType.IMAGE_JPEG;
			}
			if (formatName.equals("GIF")) {
				return MediaType.IMAGE_GIF;
			}
			if (formatName.equals("PNG")) {
				return MediaType.IMAGE_PNG;
			}
		}
		return null;
	}

	// 일반회원 목록 페이지
	@RequestMapping(value = "/umemberList", method = RequestMethod.GET)
	public String umemberList(@ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		model.addAttribute("umemberList", umemberService.list(pageRequest));

		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(umemberService.count());
		model.addAttribute("pagination", pagination);

		return "member/umemberList";
	}

	// 공지사항 목록
	@GetMapping("/noticeList")
	public String noticeList() {
		return "notice/noticeList";
	}

	// 극단 FAQ 목록

	@GetMapping("/tfaqList")
	public String tfaqList() {
		return "tfaq/tfaqList";
	}

	// 사용자 FAQ 목록

	@GetMapping("/ufaqList")
	public String ufaqList() {
		return "ufaq/ufaqList";
	}
}
