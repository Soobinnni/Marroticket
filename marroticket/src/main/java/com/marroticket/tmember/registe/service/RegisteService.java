
package com.marroticket.tmember.registe.service;

import com.marroticket.umember.play.domain.PlayVO;

public interface RegisteService {

	public void registePlay(PlayVO playVO) throws Exception;

	public Integer tnumberFind(String tId) throws Exception;
}
