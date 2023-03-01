/*
 * package com.marroticket.umember.play.service;
 * 
 * import java.util.List;
 * 
 * import org.springframework.beans.factory.annotation.Autowired; import
 * org.springframework.stereotype.Service;
 * 
 * import com.marroticket.common.domain.PageRequest; import
 * com.marroticket.mapper.PlayMapper; import
 * com.marroticket.umember.play.domain.PlayVO;
 * 
 * @Service public class PlayServiceImpl implements PlayService {
 * 
 * @Autowired private PlayMapper mapper;
 * 
 * @Override public List<PlayVO> playCurrentList() throws Exception { return
 * mapper.playCurrentList(); }
 * 
 * @Override public List<PlayVO> playPassList() throws Exception { return
 * mapper.playPassList(); }
 * 
 * @Override public List<PlayVO> playExpectedList() throws Exception { return
 * mapper.playExpectedList(); }
 * 
 * @Override public PlayVO read(Integer pnumber) throws Exception { return
 * mapper.read(pnumber); }
 * 
 * public String getPposter(Integer pnumber) throws Exception { return
 * mapper.getPposter(pnumber); }
 * 
 * // 포스터 미리보기
 * 
 * @Override public String playPoster(Integer pnumber) throws Exception { return
 * mapper.playRegistration(pnumber); }
 * 
 * // @Override // public List<PlayVO> playCurrentList(String getuGenre) throws
 * Exception { // return mapper.playCurrentList(getuGenre); // } // // @Override
 * // public List<PlayVO> playExpectedList(String getuGenre) throws Exception {
 * // return mapper.playExpectedList(getuGenre); // }
 * 
 * 
 * @Override public List<PlayVO> quickReserve() throws Exception { return
 * mapper.quickReserve(); }
 * 
 * // 관리자 추가 ************************************************
 * 
 * // 연극 등록 승인 목록
 * 
 * @Override public List<PlayVO> playApproveList(PageRequest pageRequest) throws
 * Exception { return mapper.playApproveList(pageRequest); }
 * 
 * // 연극 등록 승인 처리
 * 
 * @Override public int playApprove(PlayVO playVO) throws Exception { return
 * mapper.playApprove(playVO); }
 * 
 * // 연극 등록 반려 처리
 * 
 * @Override public int playReject(PlayVO playVO) throws Exception { return
 * mapper.playReject(playVO); }
 * 
 * // 연극 수정 승인 목록
 * 
 * @Override public List<PlayVO> playModifyList(PageRequest pageRequest) throws
 * Exception { return mapper.playModifyList(pageRequest); }
 * 
 * // 연극 수정 승인 처리
 * 
 * @Override public int playModify(PlayVO playVO) throws Exception { return
 * mapper.playModify(playVO);
 * 
 * }
 * 
 * // 연극 상세보기
 * 
 * @Override public PlayVO playDetail(Integer pnumber) throws Exception { return
 * mapper.playDetail(pnumber); }
 * 
 * // 연극 목록 총갯수
 * 
 * @Override public int count() throws Exception { return mapper.count(); }
 * 
 * @Override public int modifyCount() throws Exception { return
 * mapper.modifyCount(); }
 * 
 * }
 */