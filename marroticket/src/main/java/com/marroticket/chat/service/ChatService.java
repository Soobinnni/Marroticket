package com.marroticket.chat.service;

import java.util.Map;

import com.marroticket.chat.domain.ChatVO;

public interface ChatService {
	public void saveType(ChatVO vo) throws Exception;
	public Map<String, Object> getChatCounts() throws Exception;
}
