package com.marroticket.tmember.modify.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.marroticket.mapper.PlayMapper;
import com.marroticket.play.domain.PlayVO;

@Service
public class ModifyServiceImpl implements ModifyService {

	@Autowired
	private PlayMapper mapper;
	
	// 등록한 연극 목록
	@Override
	public List<PlayVO> playlist(Integer tNumber) throws Exception {
		System.out.println("ModifyServiceImpl 호출");
		return mapper.playlist(tNumber);
	}
	

	// 등록한 연극 상세보기
	@Override
	public PlayVO read(int pNumber) throws Exception {
		System.out.println("ModifyServiceImpl 호출");
		return mapper.read(pNumber);
	}

	
	// 등록한 연극 수정
	@Override
	public void modify(PlayVO playVO) throws Exception {
		System.out.println("ModifyServiceImpl 호출");
		mapper.modify(playVO);
	}


}
