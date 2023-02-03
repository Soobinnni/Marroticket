package com.marroticket.tmember.member.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.marroticket.tmember.registe.service.RegisteService;
import com.marroticket.umember.play.domain.PlayVO;

import lombok.extern.java.Log;

@Log
@Controller
@RequestMapping("/theater")
@MapperScan(basePackages = "com.marroticket.mapper")
public class TmemberController {

	@Autowired
	RegisteService registeService;

	@Value("${upload.path}")
	private String uploadPath;

	@GetMapping("")
	public String home() {
		return "tmemberhome";
	}

	// 연극 등록 이동
	@GetMapping("/registePlay")
	public String registeForm(@ModelAttribute("playVO") PlayVO playVO) throws Exception {

		return "registe.registePlay";
	}

	// 연극 등록 처리
	@PostMapping("/registePlay")
	public String registePlay(@ModelAttribute("playVO") @Validated PlayVO playVO, BindingResult result)
			throws Exception {

		MultipartFile ptheaterMap = playVO.getPtheaterMap();
		MultipartFile pposter = playVO.getPposter();

		String ptheaterMapUrl = uploadFile(ptheaterMap.getOriginalFilename(), ptheaterMap.getBytes());
		String pposterUrl = uploadFile(pposter.getOriginalFilename(), pposter.getBytes());

		playVO.setPtheaterMapUrl(ptheaterMapUrl);
		playVO.setPposterUrl(pposterUrl);

		registeService.registePlay(playVO);

		if (result.hasErrors()) {
			List<ObjectError> list = result.getAllErrors();
			for (ObjectError error : list) {
				System.out.println(error);
			}
			return "registe.registePlay";
		}

		log.info(playVO.toString());
		return "registe.registeTemporaryComplete";
	}

	// 상연 날짜 선택 팝업 이동
	@GetMapping("/registeInfoCalendar")
	public String registeInfoCalendar(PlayVO playVO, Model model) throws Exception {

		return "tmember/registe/registeInfoCalendar";
	}

	// 등록한 연극
	@GetMapping("/playRegisteInfo")
	public String playRegisteInfo() {
		return "info.tMemberPlayRegisteInfo";
	}

	// 극단 정산
	@GetMapping("/tmemberPayment")
	public String theaterPayment() {
		return "info.tMemberPayment";
	}

	// 극단 정보 관리
	@GetMapping("/tmembermypage")
	public String theaterMemberInfo() {
		return "info.tMemberMemberInfo";
	}

	// 극단 이용약관 페이지
	@GetMapping("/tMemberAgreement")
	public String tMemberAgreement() {
		System.out.println("tMemberAgreement 호출 완료");
		return "tMemberJoin.tMemberAgreement";
	}

	// 극단 회원 가입 페이지
	@GetMapping("/tMemberJoinForm")
	public String tMemberJoinForm() {
		System.out.println("tMemberJoinForm 호출 완료");
		return "tMemberJoin.tMemberJoinForm";
	}

	// 극단 공지사항, faq

	// 극단회원 FAQ
	// 목록
	@GetMapping("/tfaqList")
	public String tfaqList() {
		return "tserviceCenter.tfaqList";
	}

	// 극단회원 Notice
	// 목록
	@GetMapping("/noticeList")
	public String noticeList() {
		return "tserviceCenter.notice";
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

	// 상품 이미지 업로드
	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		UUID uid = UUID.randomUUID();
		String createdFileName = uid.toString() + "_" + originalName;
		File target = new File(uploadPath, createdFileName);
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}

	
}
