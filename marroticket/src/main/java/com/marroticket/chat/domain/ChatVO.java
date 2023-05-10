package com.marroticket.chat.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class ChatVO {
	private int chatNumber; //챗봇 시퀀스
	private String uid;//회원 아이디
	private int chatRecommend;//챗봇 좌석추천기능 카운트
	private int chatCheck;//챗봇 예매여부확인기능 카운트
}
