package com.marroticket.mapper;

import com.marroticket.play.domain.PlayVO;

public interface RegisteMapper {

	public void registe(PlayVO playVO);

	public Integer find(String tId);

}