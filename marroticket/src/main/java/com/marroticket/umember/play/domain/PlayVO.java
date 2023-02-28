/*
 * package com.marroticket.umember.play.domain;
 * 
 * import java.util.Date;
 * 
 * 
 * import javax.validation.constraints.Max; import
 * javax.validation.constraints.NotBlank; import
 * javax.validation.constraints.NotNull; import
 * javax.validation.constraints.Pattern; import
 * javax.validation.constraints.Size;
 * 
 * import org.springframework.format.annotation.DateTimeFormat; import
 * org.springframework.web.multipart.MultipartFile;
 * 
 * import lombok.Getter; import lombok.Setter; import lombok.ToString;
 * 
 * @Getter
 * 
 * @Setter
 * 
 * @ToString public class PlayVO {
 * 
 * private int pnumber; // 연극 번호
 * 
 * @NotBlank(message = "연극명은 필수 입력 값입니다.")
 * 
 * @Size(max = 50, message = "50자 이내로 입력해주세요.") private String pname; // 연극 명
 * 
 * @Pattern(regexp = "[1-9]{1}[0-9]{0,2}", message =
 * "숫자만 입력 가능하며 최대999분까지 입력가능합니다.") private String prunningTime; // 연극
 * 소요시간(러닝타임)
 * 
 * @NotBlank(message = "극장 이름은 필수 입력 값입니다.")
 * 
 * @Size(max = 10, message = "10자 이내로 입력해주세요.") private String ptheaterName; //
 * 극장 이름
 * 
 * @NotBlank(message = "극장 주소는 필수 입력 값입니다.")
 * 
 * @Size(max = 100, message = "100자 이내로 입력해주세요.") private String
 * ptheaterAddress; // 극장 주소
 * 
 * private MultipartFile pposter; // 연극 포스터 파일 private String pposterUrl; //
 * 포스터url
 * 
 * @NotBlank(message = "기획사 정보는 필수 입력 값입니다.")
 * 
 * @Size(max = 10, message = "10자 이내로 입력해주세요.") private String pagency; // 기획사
 * 정보
 * 
 * @NotBlank(message = "캐스팅 데이터는 필수 입력 값입니다.")
 * 
 * @Size(max = 2000, message = "2000자 이내로 입력해주세요.") private String pcasting; //
 * 캐스팅 데이터
 * 
 * @NotBlank(message = "공연 줄거리는 필수 입력 값입니다.")
 * 
 * @Size(max = 4000, message = "4000자 이내로 입력해주세요.") private String pplot; // 공연
 * 줄거리
 * 
 * @Max(value = 100)
 * 
 * @Pattern(regexp = "[1-9]{1}[0-9]{0,20}", message = "좌석 개수를 정확히 입력해주세요. ")
 * private String pseatNumber; // 좌석 개수
 * 
 * @Pattern(regexp = "[1-9]{1}[0-9]{0,6}", message =
 * "숫자만 입력 가능하며 최대 7자리까지 입력할 수 있습니다.") private String pticketPrice; // 티켓 가격
 * 
 * @NotNull(message = "관람 등급은 필수 입력값입니다.") private String pratings; // 관람 등급
 * 
 * @NotNull(message = "장르 정보는 필수 입력값입니다.") private String pgenre; // 장르 정보
 * 
 * private int tnumber; // 극단 회원 번호 private int pagree;// 약관 동의 여부
 * 
 * private String pregistrationApproval;// 공연 등록 승인 여부 private String
 * pmodifyApproval;// 공연 수정 승인 여부
 * 
 * @NotNull
 * 
 * @DateTimeFormat(pattern = "yyyy-MM-dd") private Date pstartDate; // 연극 시작일
 * 
 * @NotNull
 * 
 * @DateTimeFormat(pattern = "yyyy-MM-dd") private Date pcloseDate; // 연극 종료일
 * 
 * @NotNull(message = "1회차 상연 시작 시각은 필수 입력값입니다.") private String
 * pfirstStartTime;// 1회차 상연 시작 시각
 * 
 * private String psecondStartTime;// 2회차 상연 시작 시각
 * 
 * }
 */