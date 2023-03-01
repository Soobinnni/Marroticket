package com.marroticket.mapper;

import java.util.List;

import com.marroticket.admin.payment.domain.PaymentVO;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.umember.reservation.domain.ReservationVO;

public interface PaymentMapper {

	// 정산처리
	public List<PaymentVO> paymentList(PageRequest pageRequest) throws Exception;

	// 극단 FAQ 전체 건수 반환
	public int count() throws Exception;

	// 연극 리스트
	public PlayVO play(int pNumber) throws Exception;

	// 예매 리스트
	public List<ReservationVO> reservationList(int pNumber) throws Exception;

	public PaymentVO paymentHistory(int pNumber) throws Exception;

	public void payment(PaymentVO payment) throws Exception;

}
