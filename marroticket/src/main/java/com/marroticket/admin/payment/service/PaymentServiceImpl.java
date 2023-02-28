package com.marroticket.admin.payment.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.marroticket.admin.payment.domain.PaymentVO;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.mapper.PaymentMapper;
import com.marroticket.play.domain.PlayVO;
import com.marroticket.umember.reservation.domain.ReservationVO;

@Service
public class PaymentServiceImpl implements PaymentService {

	@Autowired
	PaymentMapper mapper;

	@Override
	public List<PaymentVO> payment(PageRequest pageRequest) throws Exception {

		return mapper.paymentList(pageRequest);
	}

	@Override
	public int count() throws Exception {
		return mapper.count();
	}

	@Override
	public PaymentVO paymentHistory(int pNumber) throws Exception {

		return mapper.paymentHistory(pNumber);
	}

	@Override
	public List<ReservationVO> reservationList(int pNumber) throws Exception {
		return mapper.reservationList(pNumber);
	}

	@Override
	public PlayVO play(int pNumber) throws Exception {
		return mapper.play(pNumber);

	}

	@Override
	public void paymentcreate(PaymentVO payment) throws Exception {
		mapper.payment(payment);
	}


}
