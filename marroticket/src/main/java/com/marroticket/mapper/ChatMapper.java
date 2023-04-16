package com.marroticket.mapper;

import java.util.Map;

import com.marroticket.chat.domain.ChatVO;

public interface ChatMapper {
	public void saveType(ChatVO vo) throws Exception;
	public Map<String, Object> getChatCounts() throws Exception;
}
