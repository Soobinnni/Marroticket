package com.marroticket.chat.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.marroticket.chat.domain.ChatVO;
import com.marroticket.mapper.ChatMapper;

@Service
public class ChatServiceImpl implements ChatService {
	@Autowired
	private ChatMapper mapper;
	public void saveType(ChatVO vo) throws Exception{
		mapper.saveType(vo);
	};
	public Map<String, Object> getChatCounts() throws Exception{
		return mapper.getChatCounts();
	};
}
