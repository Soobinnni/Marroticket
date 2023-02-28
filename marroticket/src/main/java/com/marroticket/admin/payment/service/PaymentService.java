package com.marroticket.admin.payment.service;

import java.util.List;

import com.marroticket.admin.payment.domain.PaymentVO;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.umember.reservation.domain.ReservationVO;

public interface PaymentService {

	// 정산처리
	public List<PaymentVO> payment(PageRequest pageRequest) throws Exception;

	// 게시글 전체 건수를 반환한다.
	public int count() throws Exception;

	// 정산내역 호출
	public PaymentVO paymentHistory(int pNumber) throws Exception;

	// 예매 리스트 호출
	public List<ReservationVO> reservationList(int pNumber) throws Exception;

	// 연극 호출
	public PlayVO play(int pNumber) throws Exception;

	// 정산 내역 생성
	public void paymentcreate(PaymentVO payment) throws Exception;

}
