package com.marroticket.tmember.member.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.security.Principal;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Date;

import org.apache.commons.io.IOUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.marroticket.admin.payment.domain.PaymentVO;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.marroticket.common.email.domain.EmailVO;
import com.marroticket.common.email.service.EmailService;
import com.marroticket.tmember.member.service.TmemberService;
import com.marroticket.tmember.modify.service.ModifyService;
import com.marroticket.tmember.registe.service.RegisteService;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.play.service.PlayService;

import lombok.extern.slf4j.Slf4j;

import com.marroticket.tmember.member.domain.TmemberVO;

@Slf4j
@Controller
@RequestMapping("/theater")
@MapperScan(basePackages = "com.marroticket.mapper")
public class TmemberController {

	@Autowired
	RegisteService registeService;

	@Value("${upload.path}")
	private String uploadPath;

	@Value("${file.dir}") // 맥용으로 설정했으니 윈도우일땐 프로퍼티에서 설정 바꾸기
	private String uploadDir;

	@Autowired
	TmemberService tmemberService;

	@Autowired
	ModifyService modifyService;

	@Autowired
	PlayService playService;

	@Autowired
	EmailService emailService;

	@Autowired
	private PasswordEncoder passwordEncoder;

	// 극단 홈
	@GetMapping("")
	@PreAuthorize("hasRole('ROLE_TMEMBER')")
	public String home() {
		// if (등록한 연극>0) {등록한 연극 포스터} else {공지사항->공지사항 controller}
		return "redirect:/notice/noticeList";
		// return "tmemberhome";
	}

	// 연극 등록 이동
	@GetMapping("/registePlay")
	@PreAuthorize("hasRole('ROLE_TMEMBER')")
	public String registeForm(@ModelAttribute("playVO") PlayVO playVO) throws Exception {
		return "registe.registePlay";
	}

	// 연극 등록 처리
	@PostMapping("/registePlayComplete")
	@PreAuthorize("hasRole('ROLE_TMEMBER')")
	public String registePlay(@ModelAttribute("playVO") @Validated PlayVO playVO, BindingResult result)
			throws Exception {

		// 에러발생시 에러표시
		if (result.hasErrors()) {
			List<ObjectError> list = result.getAllErrors();
			for (ObjectError error : list) {
				System.out.println(error);
			}
			return "registe.registePlay";
		}

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String tId = authentication.getName();
		Integer tnumber = registeService.tnumberFind(tId);
		playVO.setTnumber(tnumber);

		// db에 저장될 포스터 파일 입력
		MultipartFile pposter = playVO.getPposter();
		String pposterUrl = uploadFile(pposter.getOriginalFilename(), pposter.getBytes());
		playVO.setPposterUrl(pposterUrl);

		registeService.registePlay(playVO);

		log.info(playVO.toString());
		return "registe.registeTemporaryComplete";
	}

	// 연극 임시등록 완료페이지
	@GetMapping("/registeTemporaryComplete")
	@PreAuthorize("hasRole('ROLE_TMEMBER')")
	public String registeTemporaryComplete() throws Exception {

		return "registe.registeTemporaryComplete";
	}

	// 극단 마이페이지 시작
	// 등록한 연극
	@GetMapping("/playRegisteInfo")
	public String playRegisteInfo(Principal principal, Model model, PlayVO playVO) throws Exception {
		System.out.println("tmemberController 호출");

		// tmember tId로 play tId 정보 가져오기
		TmemberVO tvo = tmemberService.getTmemberByTId(principal.getName());
		playVO.setTnumber(tvo.getTNumber());

		int tNumber = playVO.getTnumber();
		System.out.println("극단 회원 번호" + tNumber);

		System.out.println("극단 회원 등록한 연극 정보" + playVO);

		// 등록한 연극 배열 목록 가져오기
		List<PlayVO> playlist = new ArrayList<>();
		playlist = modifyService.playlist(tNumber);

		System.out.println("극단 회원 등록한 연극 List" + playlist);

		model.addAttribute("playlist", playlist);
		return "info.tmemberPlayRegisteInfo";
	}

	// 등록한 연극 상세 페이지
	@RequestMapping(value = "/playRegisteRead", method = RequestMethod.GET)
	public String read(int pnumber, Model model, Principal principal) throws Exception {

		// tmember tId로 play tId 정보 가져오기
		TmemberVO tvo = tmemberService.getTmemberByTId(principal.getName());
		System.out.println(pnumber);

		PlayVO vo = modifyService.read(pnumber);
		vo.setTnumber(tvo.getTNumber());

		System.out.println("등록한 연극 상세");

		// 장르표시
		switch (vo.getPgenre()) {
		case "1":
			vo.setPgenre("로맨스");
			break;
		case "2":
			vo.setPgenre("코미디");
			break;
		case "3":
			vo.setPgenre("드라마");
			break;
		case "4":
			vo.setPgenre("공포");
			break;
		case "5":
			vo.setPgenre("추리/스릴러");
			break;
		case "6":
			vo.setPgenre("판타지");
			break;
		case "7":
			vo.setPgenre("시대/역사");
			break;
		}

		// 연극 등록 승인 상태 0:미승인 1:승인 2:반려
		if ("0".equals(vo.getPregistrationApproval())) {
			vo.setPregistrationApproval("미승인 : 관리자 승인 중에 있습니다");
		} else if ("1".equals(vo.getPregistrationApproval())) {
			vo.setPregistrationApproval("승인 : 연극이 정상등록 되었습니다");
		} else {
			vo.setPregistrationApproval("반려 : 연극 정보를 정확히 확인하고 변경해주세요");
		}

		// 연극 등록 수정 상태 0:수정 가능 1:수정 불가
		if ("0".equals(vo.getPmodifyApproval())) {
			vo.setPmodifyApproval("수정 가능 (연극 정상 등록/수정 승인) 상태");
		} else {
			vo.setPmodifyApproval("수정 불가 : 수정 내용 관리자 확인 중에 있습니다");
		}

		model.addAttribute("playVO", vo);

		return "info.tmemberPlayRegisteRead";

	}

	// 포스터 미리보기
	@ResponseBody
	@RequestMapping("/playPoster")
	public ResponseEntity<byte[]> ImageFile(Integer pnumber, Principal principal) throws Exception {

		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		// tmember tId로 play tId 정보 가져오기
		TmemberVO tvo = tmemberService.getTmemberByTId(principal.getName());
		System.out.println(pnumber);

		PlayVO vo = modifyService.read(pnumber);
		vo.setTnumber(tvo.getTNumber());
		System.out.println("포스터 url : " + vo.getPposterUrl());
		String fileName = playService.playPoster(pnumber);

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

	// 연극 수정 페이지
	@RequestMapping(value = "/playModify", method = RequestMethod.GET)
	public String modifyPlay(int pnumber, Model model, Principal principal) throws Exception {

		// tmember tId로 play tId 정보 가져오기
		TmemberVO tvo = tmemberService.getTmemberByTId(principal.getName());
		System.out.println(pnumber);

		PlayVO vo = modifyService.read(pnumber);
		vo.setTnumber(tvo.getTNumber());

		System.out.println("등록한 연극 상세");

		model.addAttribute("playVO", vo);

		return "modify.tmemberPlayModify";
	}

	// 연극 수정 처리
	@RequestMapping(value = "/playModify", method = RequestMethod.POST)
	public String modify(@ModelAttribute("playVO") PlayVO playVO, HttpServletRequest request, RedirectAttributes rttr,
			Principal principal, Model model, int pnumber) throws Exception {

		System.out.println("수정 처리 Controller 호출");
		System.out.println(pnumber);

		// 수정 처리
		modifyService.modify(playVO);

		log.info(playVO.toString());

		// 업데이트 된 연극 정보 가져오기
		PlayVO updatedVO = modifyService.read(pnumber);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("등록한 연극 수정처리");

		return "redirect:/theater/modifyTemporaryComplete";
	}

	// 연극 임시등록 완료페이지
	@GetMapping("/modifyTemporaryComplete")
	public String modifyTemporaryComplete(PlayVO playVO, Model model) throws Exception {

		return "modify.modifyTemporaryComplete";
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

	// 극단 정산
	@GetMapping("/tmemberPayment")
	public String theaterPayment(Model model) throws Exception {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String tId = authentication.getName();

		List<PaymentVO> list;
		list = tmemberService.theaterPayment(tId);
		model.addAttribute("theaterPayment", list);

		return "info.tmemberPayment";
	}

	// 극단 내 정보
	@GetMapping("/tmembermypage")
	// @PreAuthorize("hasRole('ROLE_TMEMBER')")
	public String tmemberMemberInfo(Model model) throws Exception {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("극단 마이페이지 정보 조회 호출");
		String tId = authentication.getName();

		// 서비스에서 아이디로 정보 불러오기
		TmemberVO vo = tmemberService.getTmemberByTId(tId);

		System.out.println(vo.getTmemberAuthList().get(0).getTNumber());

		// 사업자 등록 구분 1:개인 2:기업
		// vo.getTBusinessRegistration().equals("1")
		if ("1".equals(vo.getTBusinessRegistration())) {
			vo.setTBusinessRegistration("개인");
		} else {
			vo.setTBusinessRegistration("기업");
		}
		
		// 극단 가입 승인 여부 0:미승인 1:승인 2:반려
		switch (vo.getTAuth()) {
		case "0":
			vo.setTAuth("미승인");
			break;
		case "1":
			vo.setTAuth("승인");
			break;
		default:
			vo.setTAuth("반려");
			break;
		}

		System.out.println("극단 정보 : " + vo);
		model.addAttribute("vo", vo);
		return "info.tmemberMemberInfo";
	}

	// 회원정보 수정 페이지
	@RequestMapping(value = "/tmemberModify", method = RequestMethod.GET)
	public String tmemberMemberModify(Model model) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String tId = authentication.getName();

		// 서비스에서 아이디로 정보 불러오기
		TmemberVO vo = tmemberService.getTmemberByTId(tId);

		model.addAttribute("vo", vo);
		return "info.tmemberMemberModify";
	}

	@RequestMapping(value = "/tmemberModify", method = RequestMethod.POST)
	public String updateMyPage(@ModelAttribute("vo") TmemberVO vo, HttpServletRequest request,
			@RequestParam("tPassword") String tPassword, @RequestParam("changePw") String changePw,
			@RequestParam("confirmPw") String confirmPw, RedirectAttributes rttr) throws Exception {
		System.out.println("수정 호출");

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String tId = authentication.getName();

		// 비밀번호 암호화
		String inputPassword = tPassword;
		vo.setTPassword(passwordEncoder.encode(inputPassword));

		TmemberVO originalVO = tmemberService.getTmemberByTId(tId);

		// 1. 로그인한 비밀번호 확인
		if (!passwordEncoder.matches(inputPassword, originalVO.getTPassword())) {
			System.out.println("에러 : 기존 비밀번호에 입력된 값이 없거나 틀린 비밀번호 입니다.");
			rttr.addFlashAttribute("msg", "에러 : 기존 비밀번호에 입력된 값이 없거나 틀린 비밀번호 입니다.");
			return "redirect:/theater/tmemberModify";
		}

		// 2. 변경할 비밀번호와 로그인한 비밀번호가 일치하면 오류
		if (passwordEncoder.matches(changePw, originalVO.getTPassword())) {
			System.out.println("에러 : 기존 비밀번호와 같은 비밀번호를 사용 할 수 없습니다.");
			rttr.addFlashAttribute("emsg", "에러 : 기존 비밀번호와 같은 비밀번호를 사용 할 수 없습니다.");
			return "redirect:/theater/tmemberModify";
		}

		// 변경할 비밀번호가 빈칸도 아니고 기존 비밀번호랑도 다르면
		if (!changePw.isEmpty() && !changePw.equals(inputPassword)) {
			// 변경한 비밀번호도 암호화
			vo.setTPassword(passwordEncoder.encode(changePw));

			// 비밀번호 변경시 로그아웃
			HttpSession session = request.getSession(false);
			if (session != null) {
				session.invalidate();
			}
		}
		tmemberService.modify(vo);

		// 업데이트된 사용자 정보 가져오기
		TmemberVO updatedVO = tmemberService.getTmemberByTId(tId);

		// 비밀번호 변경 없이 다른 정보들을 수정할 경우 마이페이지상태로 돌아감
		return "redirect:/theater/tmembermypage";
	}

	// 극단 마이페이지 끝

	// 극단 이용약관 페이지
	@GetMapping("/tmemberAgreement")
	public String tmemberAgreement() {
		System.out.println("tmemberAgreement 호출 완료");
		return "tMemberJoin.tmemberAgreement";
	}

	// 극단 회원 가입 페이지

	@GetMapping("/tmemberJoinForm")
	public String tmemberJoinForm(@ModelAttribute("tmember") TmemberVO tmember) {
		System.out.println("tmemberJoinForm 호출 완료");
		return "tMemberJoin.tmemberJoinForm";
	}

	// 아이디 중복체크
	@PostMapping("/tIdCheck")
	public ResponseEntity<String> tIdCheck(TmemberVO tmember) throws Exception {
		System.out.println("중복 아이디 체크 컨트롤러 불러옴\numember : " + tmember.toString());
		int result = tmemberService.tIdCheck(tmember);
		ResponseEntity<String> entity = null;
		System.out.println(result);
		if (result == 1) {
			entity = new ResponseEntity<>("overlap", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<>("no overlap", HttpStatus.OK);
		}
		return entity;
	}

	// 극단 회원 가입
	@PostMapping("/signUp")
	public String signUp(@ModelAttribute("tmember") @Validated TmemberVO tmember, BindingResult result)
			throws Exception {
		log.info("signUp 호출");

		// 극단 회원 가입 실패시 리스트로 나열
		if (result.hasErrors()) {
			List<ObjectError> list = result.getAllErrors();
			for (ObjectError error : list) {
				System.out.println(error);
			}
			return "tMemberJoin.tmemberJoinForm";
		}

		MultipartFile tBusinessRegistrationImage = tmember.getTBusinessRegistrationImage();

		String tBusinessRegistrationImageUrl = uploadImage(tBusinessRegistrationImage.getOriginalFilename(),
				tBusinessRegistrationImage.getBytes());

		tmember.setTBusinessRegistrationImageUrl(tBusinessRegistrationImageUrl);

		// 비밀번호 암호화
		String inputPassword = tmember.getTPassword();
		tmember.setTPassword(passwordEncoder.encode(inputPassword));

		// 가입 성공시 등록 성공 페이지로 이동
		tmemberService.register(tmember);
		System.out.println("등록성공" + tmember.toString());
		return "tMemberJoin.tmemberJoinSuccess";
	}

	// 극단 회원가입 성공 페이지
	@GetMapping("/tmemberJoinSuccess")
	public String tmemberJoinSuccess() {
		System.out.println("tmemberJoinSuccess호출 완료");
		return "tMemberJoin.tmemberJoinSuccess";
	}

	// footer
	@GetMapping("/privacy")
	public String privacy() {
		return "tmember.footer.privacy";
	}

	@GetMapping("/companyinfo")
	public String companyinfo() {
		return "tmember.footer.companyinfo";
	}

	@GetMapping("/termsofuse")
	public String termsofuse() {
		return "tmember.footer.termsofuse";
	}

	@GetMapping("/tmembertermsofuse")
	public String termsofuse(Model model) {
		model.addAttribute("tmember", "tmember");
		return "tmember.footer.tmembertermsofuse";
	}

	@GetMapping("/umembertermsofuse")
	public String umembertermsofuse(Model model) {
		model.addAttribute("tmember", "tmember");
		return "tmember.footer.umembertermsofuse";
	}

	// 극단회원 아이디 찾기
	@PostMapping("/findId")
	public ResponseEntity<String> findId(@RequestBody TmemberVO tmember) throws Exception {
		// 값이 정상적으로 입력됐을 때, db 조회
		String tId = tmemberService.findId(tmember);

		// 응답
		if (tId != null && tId.length() > 0) {
			sendEmail(("아이디" + tId), tmember.gettOwnerEmail()); // 아이디 이메일 발송
			return new ResponseEntity<String>(tId, HttpStatus.OK);
		} else {
			return new ResponseEntity<String>("fail", HttpStatus.OK);
		}
	}

	// 비밀번호 찾기 - 임시비밀번호 업데이트
	@PostMapping("/findPassword")
	public ResponseEntity<String> findPassword(@RequestBody TmemberVO tmember) throws Exception {
		ResponseEntity<String> entity;

		// 임시비밀번호 생성(15자리)
		String temporaryPassword = getRamdomPassword(15);
		tmember.setTPassword(temporaryPassword);

		// 비밀번호 암호화
		tmember.setTPassword(passwordEncoder.encode(temporaryPassword));

		// 임시비밀번호로 업데이트 : 업데이트는 where조건(id, email이 db데이터 조회 시, 부합)에 따라 성공/실패
		int success = tmemberService.passwordUpdate(tmember);
		if (success != 0) { // 업데이트 성공
			sendEmail(temporaryPassword, tmember.gettOwnerEmail()); // 임시비밀번호 발송
			entity = new ResponseEntity<String>("send", HttpStatus.OK);
			// 임시비밀번호 이메일 발송
		} else { // 업데이트 실패
			entity = new ResponseEntity<String>("fail", HttpStatus.OK);
		}
		return entity;
	}

	// 아이디 또는 임시비밀번호 이메일 발송
	public void sendEmail(String idOrTemporaryPassword, String tOwnerEmail) throws Exception {
		String title = null;
		EmailVO email = new EmailVO(); // 이메일 객체

		if (idOrTemporaryPassword.substring(0, 3).equals("아이디")) {// 문자열 끝자리가 '아이디'일때
			title = "마로티켓입니다. 아이디를 확인해주세요"; // 이메일 제목
			idOrTemporaryPassword = idOrTemporaryPassword.substring(3);
			email.setId(idOrTemporaryPassword);
		} else {
			title = "마로티켓입니다. 임시비밀번호를 확인해주세요"; // 이메일 제목
			email.setPassword(idOrTemporaryPassword);
		}

		email.setAddress(tOwnerEmail);
		email.setTitle(title);

		// 이메일 발송
		emailService.sendTmemberEmail(email);
		// console 확인
		System.out.println("idOrTemporaryPassword 이메일 발송 완료");
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

	// 포스터 이미지 업로드
	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		UUID uid = UUID.randomUUID();
		String createdFileName = uid.toString() + "_" + originalName;
		File target = new File(uploadPath, createdFileName);
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}

	// 사업자등록증 사본 이미지 업로드
	private String uploadImage(String originalName, byte[] fileData) throws Exception {
		UUID uid = UUID.randomUUID();
		String createdFileName = uid.toString() + "_" + originalName;
		File target = new File(uploadDir, createdFileName);
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}

}
