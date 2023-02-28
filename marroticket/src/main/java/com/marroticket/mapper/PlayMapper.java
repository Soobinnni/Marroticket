package com.marroticket.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.marroticket.common.domain.PageRequest;
import com.marroticket.play.domain.PlayVO;

@Mapper
public interface PlayMapper {

	public List<PlayVO> playCurrentList() throws Exception;

	public List<PlayVO> playPassList() throws Exception;

	public List<PlayVO> playExpectedList() throws Exception;

	/*
	 * public PlayVO read(Integer pNumber) throws Exception;
	 */
	// 극단 등록한 연극 포스터 보기
	public String getPposter(Integer pnumber) throws Exception;
	
	// 극단 등록한 연극 포스터 미리보기
	public String playRegistration(Integer pnumber) throws Exception;

	// 관리자 추가************************************************

	// 연극 등록 승인 목록
	public List<PlayVO> playApproveList(PageRequest pageRequest) throws Exception;

	// 연극 등록 승인 처리
	public int playApprove(PlayVO playVO) throws Exception;

	// 연극 등록 승인 처리
	public int playReject(PlayVO playVO) throws Exception;

	// 연극 수정 승인 목록
	public List<PlayVO> playModifyList(PageRequest pageRequest) throws Exception;

	// 연극 수정 승인 처리
	public int playModify(PlayVO playVO) throws Exception;

	// 연극 상세보기
	public PlayVO playDetail(Integer pnumber) throws Exception;

	// 연극 목록 승인 총 갯수
	public int count() throws Exception;

	public int modifyCount() throws Exception;

	// 등록한 연극 목록
	public List<PlayVO> playlist(Integer tNumber) throws Exception;

	// 등록한 연극 상세보기
	public PlayVO read(int pnumber) throws Exception;

	// 등록한 연극 수정
	public void modify(PlayVO playVO) throws Exception;

	/*
	 * public List<PlayVO> quickReserve() throws Exception;
	 */

}
