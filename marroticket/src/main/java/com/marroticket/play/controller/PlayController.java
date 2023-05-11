package com.marroticket.play.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.marroticket.play.domain.PlayVO;
import com.marroticket.play.service.PlayService;

//@PreAuthorize("hasRole('ROLE_UMEMBER')")
@RequestMapping("/play")
@Controller
@MapperScan(basePackages = "com.marroticket.mapper")
public class PlayController {

	@Value("${upload.path}")
	private String uploadPath;
	
	@Value("${apikey.chat}")
	private String chatApiKey;

	@Autowired
	private PlayService playService;

	// 현재 상연 페이지
	@GetMapping("/playCurrentList")
	public String playCurrentList(Model model) throws Exception {

		List<PlayVO> playCurrentList = new ArrayList<>();
		playCurrentList = playService.playCurrentList();
		model.addAttribute("playCurrentList", playCurrentList);

		return "play.playCurrentList";
	}

	// 지난 상연 페이지
	@GetMapping("/playPassList")
	public String playPassList(Model model) throws Exception {

		List<PlayVO> playPassList = new ArrayList<>();
		playPassList = playService.playPassList();
		model.addAttribute("playPassList", playPassList);

		return "play.playPassList";
	}

	// 상연 예정 페이지
	@GetMapping("/playExpectedList")
	public String playExpectedList(Model model) throws Exception {

		List<PlayVO> playExpectedList = new ArrayList<>();
		playExpectedList = playService.playExpectedList();
		model.addAttribute("playExpectedList", playExpectedList);

		return "play.playExpectedList";
	}

	// 연극 공연 정보 상세 페이지
	@GetMapping("/playDetail")
	public String playDetail(Model model, int pNumber) throws Exception{
		PlayVO play = playService.read(pNumber);
		
		//관람등급 set
		play.setPratings(ratingSet(play));
		//장르 정보 set
		play.setPgenre(genreSet(play));
		System.out.println(play);

		model.addAttribute("play", play);
		model.addAttribute("chatApiKey", chatApiKey);
		
		return "playDetail";
	}

	// 연극 공연

	//관람등급 set
	public String ratingSet(PlayVO play) {
		switch (play.getPratings().charAt(0)) {
		case '1':
			return "전체";
		case '2':
			return "12세 이상";
		case '3':
			return "15세 이상";
		case '4':
			return "18세 이상";
		default : 
			return null;
		}
	}
	//장르정보 set
	public String genreSet(PlayVO play) {
		switch (play.getPgenre().charAt(0)) {
		case '1':
			return "로맨스극";
		case '2':
			return "코미디극";
		case '3':
			return "드라마극";
		case '4':
			return "공포극";
		case '5':
			return "추리스릴러극";
		case '6':
			return "판타지극";
		case '7':
			return "시대/역사극";
		default:
			return null;
		}
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
