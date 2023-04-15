package com.marroticket.chat.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.marroticket.chat.domain.ChatVO;
import com.marroticket.chat.service.ChatService;

@Controller
@RequestMapping("/chat")
public class ChatController {
	
	@Autowired
	private ChatService service;
	
	@PostMapping("/saveType")
	public ResponseEntity<String> saveType(@RequestBody String type, Principal principal) throws Exception{
		ChatVO vo = new ChatVO();
		if (type=="recommend") {
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
}
