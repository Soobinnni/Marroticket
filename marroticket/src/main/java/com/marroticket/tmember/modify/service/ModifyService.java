package com.marroticket.tmember.modify.service;

import java.util.List;

import com.marroticket.play.domain.PlayVO;

public interface ModifyService {

	// 등록한 연극 목록
	public List<PlayVO> playlist(Integer tNumber) throws Exception;
	
	// 등록한 연극 상세보기
	public PlayVO read(int pnumber) throws Exception;
	
	// 등록한  연극 수정
	public void modify(PlayVO playVO) throws Exception;

}
