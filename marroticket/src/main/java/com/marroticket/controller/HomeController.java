package com.marroticket.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.marroticket.play.domain.PlayVO;
import com.marroticket.play.service.PlayService;

import org.springframework.ui.Model;

@Controller
public class HomeController {
	@Value("${upload.path}")
	private String uploadPath;

	@Autowired
	private PlayService playService;

	@GetMapping("/")
	public String home(Model model) throws Exception {

		List<PlayVO> playCurrentList = new ArrayList<>(); //상연 중
		playCurrentList = playService.playCurrentList();
		model.addAttribute("playCurrentList", playCurrentList);

		return "home";
	}

	// 회원가입
	@GetMapping("/join")
	public String joinChoose() {
		return "joinChoose";
	}

	@GetMapping("/umemberJoinForm")
	public String userJoin() {
		return "uMemberJoin.umemberJoinForm";
	}

	@GetMapping("/tmemberJoinForm")
	public String theaterJoin() {
		return "tMemberJoin.tmemberJoinForm";
	}

	// 회원 관련
	@GetMapping("/loginChoose")
	public String login() {
		return "loginChoose";
	}

	// 아이디 찾기
	@GetMapping("/memberFindId")
	public String idFindChoose() {
		return "memberFind.Id";
	}

	// 비밀번호 찾기
	@GetMapping("/memberFindPassword")
	public String passwordFindChoose() {
		return "memberFind.Password";
	}

	// footer
	@GetMapping("/privacy")
	public String privacy() {
		return "footer.privacy";
	}

	@GetMapping("/companyinfo")
	public String companyinfo() {
		return "footer.companyinfo";
	}

	@GetMapping("/umembertermsofuse")
	public String umembertermsofuse(Model model) {
		model.addAttribute("umember", "umember");
		return "footer.umembertermsofuse";
	}

	@GetMapping("/tmembertermsofuse")
	public String tmembertermsofuse(Model model) {
		model.addAttribute("umember", "umember");
		return "footer.tmembertermsofuse";
	}

	// 고객센터
	// 일반회원 FAQ
	// 목록
	@GetMapping("/ufaqList")
	public String ufaqList() {
		return "serviceCenter.ufaqList";
	}

	// 일반회원 문의 사항
	@GetMapping("/serviceCenter/otherInquiries")
	public String otherInquiries() {
		return "serviceCenter.otherInquiries";
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
}
