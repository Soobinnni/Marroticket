package com.marroticket.play.service;

import java.util.List;

import com.marroticket.common.domain.PageRequest;
import com.marroticket.play.domain.PlayVO;

public interface PlayService {
	public List<PlayVO> playCurrentList() throws Exception;

	public List<PlayVO> playPassList() throws Exception;

	public List<PlayVO> playExpectedList() throws Exception;

	/*
	 * public List<PlayVO> quickReserve() throws Exception;
	 */
	
	// 극단 등록한 연극
	public PlayVO read(Integer pnumber) throws Exception;

	public String getPposter(Integer pnumber) throws Exception;
	
	// 포스터 미리보기
	public String playPoster(Integer pnumber) throws Exception;


	// 관리자 추가************************************************

	// 연극 등록 승인 목록
	public List<PlayVO> playApproveList(PageRequest pageRequest) throws Exception;

	// 연극 등록 승인 처리
	public int playApprove(PlayVO playVO) throws Exception;

	// 연극 등록 반려 처리
	public int playReject(PlayVO playVO) throws Exception;

	// 연극 수정 목록
	public List<PlayVO> playModifyList(PageRequest pageRequest) throws Exception;

	// 연극 수정 승인 처리
	public int playModify(PlayVO playVO) throws Exception;

	// 연극 상세보기 페이지
	public PlayVO playDetail(Integer pnumber) throws Exception;

	// 연극 목록 전체 건수를 반환한다.
	public int count() throws Exception;

	public int modifyCount() throws Exception;

//	public List<PlayVO> playCurrentList(String getuGenre) throws Exception;
//	public List<PlayVO> playExpectedList(String getuGenre) throws Exception;

	/*
	 * public List<PlayVO> quickReserve() throws Exception;
	 */

}
