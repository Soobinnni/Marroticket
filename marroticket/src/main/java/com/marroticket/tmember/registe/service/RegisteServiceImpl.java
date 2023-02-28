
package com.marroticket.tmember.registe.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.marroticket.mapper.RegisteMapper;
import com.marroticket.mapper.TmemberMapper;
import com.marroticket.play.domain.PlayVO;

@Service
public class RegisteServiceImpl implements RegisteService {

	@Autowired
	private RegisteMapper mapper;

	@Autowired
	private TmemberMapper tmembermapper;

	@Override
	public void registePlay(PlayVO playVO) throws Exception {
		mapper.registe(playVO);
	}

	@Override
	public Integer tnumberFind(String tId) throws Exception {
		return mapper.find(tId);

	}
}