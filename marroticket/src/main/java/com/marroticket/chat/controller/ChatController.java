package com.marroticket.chat.controller;

import java.security.Principal;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.marroticket.chat.domain.ChatVO;
import com.marroticket.chat.service.ChatService;

import org.springframework.ui.Model;

@Controller
@RequestMapping("/chat")
public class ChatController {
	
	@Autowired
	private ChatService service;

	//chat 유형 선택 저장
	@PostMapping("/saveType")
	public ResponseEntity<String> saveType(@RequestBody  Map<String, Object> data, Principal principal) throws Exception{
		ChatVO vo = new ChatVO();
		String type = (String) data.get("type");
		if ("recommend".equals(type)) {
			vo.setChatRecommend(1);
		} else {
			vo.setChatCheck(1);
		}
		if (principal != null) {
			vo.setUid(principal.getName());
		} else {
			vo.setUid("비회원");
		}
		service.saveType(vo);
		return new ResponseEntity<>("success", HttpStatus.OK);
	}
	//chat 통계
	@GetMapping("/readStatistics")
	public String readStatistics(Model model) throws Exception{
		Map<String, Object> chatCount = service.getChatCounts();
		model.addAttribute("chat", chatCount);
		return "chat.chat_statistics";
	}
}
