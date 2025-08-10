package com.itwillbs.clish.DB;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Random;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequiredArgsConstructor
public class DBController {
	public final DBService DBService;
	@GetMapping("addUserDB")
	public String addDB(UserDTO user) {
		for(int i = 0; i < 100; i++) {
			user.setUserIdx(makeIdx());
			user.setUserName(makeName());
			user.setUserRepName(makeRepName());
			user.setUserBirth(makeRandomBirth());
			user.setUserGender("F");
			user.setUserId("comuser"+i);
			user.setUserPassword("$2y$04$I/1ts9VPmN5oNmgcUMe/mu5ea6H1v8NoIV22bdj/uCkQ/behALsWu");
			user.setUserEmail(user.getUserId() + "@test.com");
			user.setUserPhoneNumber(makeRandomPhonenumber());
			user.setUserPhoneNumberSub(makeRandomPhonenumber());
			user.setUserPostcode("더미");
			user.setUserAddress1("덤더미");
			user.setUserAddress2("더더더미");
			user.setUserStatus(1);
			user.setUserRegDate(makeRegDate());
			user.setUserType(1);
			user.setUserPenaltyCount(0);
			DBService.inputUserData(user);
		}
		return "";
	}
	
	
	public Date makeRegDate() {
		Random random = new Random();
		
		// Calendar 객체 생성
	    Calendar calendar = Calendar.getInstance();

	    // 시작 날짜: 1950-01-01
	    calendar.set(2021, Calendar.JANUARY, 1, 0, 0, 0);
	    long startMillis = calendar.getTimeInMillis();

	    // 종료 날짜: 2010-12-31
	    calendar.set(2025, Calendar.DECEMBER, 31, 23, 59, 59);
	    long endMillis = calendar.getTimeInMillis();

	    // 시작과 끝 사이에서 랜덤으로 밀리초 선택
	    long randomMillisSinceEpoch = startMillis + ((long)(random.nextDouble() * (endMillis - startMillis)));

	    // Date 객체 생성 후 반환
	    return new Date(randomMillisSinceEpoch);
		
	}
	
	//폰넘버
	public String makeRandomPhonenumber() {
		Random random = new Random();

	    // 중간 4자리 번호 생성 (0000 ~ 9999)
	    int middle = random.nextInt(10000);

	    // 마지막 4자리 번호 생성 (0000 ~ 9999)
	    int last = random.nextInt(10000);

	    // 각 4자리는 0으로 시작할 수 있으므로, 4자리 맞게 포맷팅
	    String middleStr = String.format("%04d", middle);
	    String lastStr = String.format("%04d", last);

	    return "010-" + middleStr + "-" + lastStr;
	}
	
	//아이디
	public String makeRandomId() {
	    Random random = new Random();

	    // 길이 4~10 사이 랜덤 결정
	    int length = 4 + random.nextInt(7); // 4~10

	    StringBuilder id = new StringBuilder();

	    // 첫 글자는 반드시 영문자 (대문자 or 소문자)
	    boolean upper = random.nextBoolean();
	    char firstChar = upper ? 
	        (char) ('A' + random.nextInt(26)) : 
	        (char) ('a' + random.nextInt(26));
	    id.append(firstChar);

	    // 두 번째 글자부터는 영문자 또는 숫자 혼용
	    for (int i = 1; i < length; i++) {
	        int option = random.nextInt(3); // 0: 대문자, 1: 소문자, 2: 숫자

	        switch(option) {
	            case 0:
	                id.append((char) ('A' + random.nextInt(26)));
	                break;
	            case 1:
	                id.append((char) ('a' + random.nextInt(26)));
	                break;
	            case 2:
	                id.append((char) ('0' + random.nextInt(10)));
	                break;
	        }
	    }

	    return id.toString();
	}
	
	//생일
	public Date makeRandomBirth() {
		Random random = new Random();
		
		// Calendar 객체 생성
	    Calendar calendar = Calendar.getInstance();

	    // 시작 날짜: 1950-01-01
	    calendar.set(1950, Calendar.JANUARY, 1, 0, 0, 0);
	    long startMillis = calendar.getTimeInMillis();

	    // 종료 날짜: 2010-12-31
	    calendar.set(2010, Calendar.DECEMBER, 31, 23, 59, 59);
	    long endMillis = calendar.getTimeInMillis();

	    // 시작과 끝 사이에서 랜덤으로 밀리초 선택
	    long randomMillisSinceEpoch = startMillis + ((long)(random.nextDouble() * (endMillis - startMillis)));

	    // Date 객체 생성 후 반환
	    return new Date(randomMillisSinceEpoch);
		
	}
	
	
	
	//닉네임
	public String makeRepName() {
		Random random = new Random();
		
		// 닉네임에 사용할 문자 범위: 한글 자음/모음 제외, 
		// 여기서는 한글 자모를 제외하고, 간단히 한글 완성형 음절, 영문 대문자/소문자, 숫자 포함
		// 한글 완성형 음절 범위: 0xAC00 ~ 0xD7A3
		// 영문 대소문자: A-Z, a-z
		// 숫자: 0-9
		
		// 사용할 문자들을 배열로 만들기보다 각 범위별 랜덤 선택하는 방식을 썼어요.
		
		// 닉네임 길이 (2~10글자)
		int length = 2 + random.nextInt(9); // 2~10
		
		StringBuilder nickname = new StringBuilder();
		
		for (int i = 0; i < length; i++) {
			int charType = random.nextInt(3); // 0: 한글, 1: 영어, 2: 숫자
			
			switch (charType) {
			case 0: // 한글 음절 랜덤 생성 (완성형 음절)
				int hangulStart = 0xAC00;
				int hangulEnd = 0xD7A3;
				char hangulChar = (char) (hangulStart + random.nextInt(hangulEnd - hangulStart + 1));
				nickname.append(hangulChar);
				break;
				
			case 1: // 영어 대소문자 랜덤 생성
				boolean upper = random.nextBoolean();
				char englishChar;
				if (upper) {
					englishChar = (char) ('A' + random.nextInt(26));
				} else {
					englishChar = (char) ('a' + random.nextInt(26));
				}
				nickname.append(englishChar);
				break;
				
			case 2: // 숫자 랜덤 생성
				char digitChar = (char) ('0' + random.nextInt(10));
				nickname.append(digitChar);
				break;
			}
		}
		
		return nickname.toString();
	}
	
	//이름
	public String makeName() {
	    Random random = new Random();
	    // 가능한 성씨들
	    String[] surnames = {"김", "이", "박", "최", "송", "강", "신", "홍"};
	    // 성 랜덤 선택
	    String surname = surnames[random.nextInt(surnames.length)];
	    
	    // 이름 길이 결정 (2~3글자)
	    int nameLength = 2 + random.nextInt(2); // 2 또는 3
	    
	    int[] choOptions = {0, 2, 3, 5, 6, 7, 9, 10, 11, 12, 13, 16, 17, 18};
	    int[] jongOptions = new int[27];
	    int idx = 0;
	    for (int i = 0; i < 28; i++) {
	        if (i != 27) {  // 27은 쌍자음 종성(ㅆ) 이므로 제외
	            jongOptions[idx++] = i;
	        }
	    }
	    StringBuilder name = new StringBuilder();
	    
	    
	    for (int i = 0; i < nameLength; i++) {
	        int cho = choOptions[random.nextInt(choOptions.length)];  // 쌍자음 초성 제외
	        int jung = random.nextInt(21);                            // 중성은 그대로 전체 범위 허용
	        int jong = jongOptions[random.nextInt(jongOptions.length)]; // 쌍자음 종성 제외

	        char syllable = (char) (0xAC00 + (cho * 21 * 28) + (jung * 28) + jong);
	        name.append(syllable);
	    }

	    // 성 + 이름 합치기
	    return surname + name.toString();
	    
	}
	
	// IDX 생성
	public String makeIdx() {
		String prefix = "user";
//		String prefix = "comp";
		Random random = new Random();
		LocalDateTime start = LocalDateTime.of(2010, 1, 1, 0, 0, 0);
		LocalDateTime end = LocalDateTime.of(2025, 8, 31, 23, 59, 59);
		// start부터 end 사이의 초(seconds) 차를 구한다
		long startEpoch = start.toEpochSecond(java.time.ZoneOffset.UTC);
		long endEpoch = end.toEpochSecond(java.time.ZoneOffset.UTC);
		
		// start와 end 사이의 랜덤한 초 생성
		long randomEpoch = startEpoch + ((long) (random.nextDouble() * (endEpoch - startEpoch)));
		
		// 랜덤 초를 LocalDateTime으로 변환
		LocalDateTime randomDateTime = LocalDateTime.ofEpochSecond(randomEpoch, 0, java.time.ZoneOffset.UTC);
		
		// 포맷팅
		String randomDate = randomDateTime.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
		String userIdx = prefix + randomDate;
		
		return userIdx;
	}
	
	@GetMapping("addReservationDB")
	public void addReservation(DBReservationPaymentDTO payment) {
		for(int i=0; i < 200; i++) {
			//RESERVATION
			payment.setReservationIdx(makeRandomResrvationIdx());
			payment.setUserIdx(selectUserIdx());
			payment.setReservationMembers(1);
			payment.setReservationClassDate(makeReservationClassDate());
			payment.setReservationCom(makeReservationCom());
			payment.setClassIdx("CLSFAKEDATA");
			payment.setReservationStatus(2);
			//PAYMENT_INFO
			payment.setImpUid(makeRandomimpUid());
			//ReservationIDX
			//ClassTitle : 클래스 타이틀
			payment.setAmount(makeRandomAmount());
			payment.setStatus("paid");
			//userName
			payment.setPayMethod("point");
			payment.setRequestTime(makeRequestTime()*1000);
			payment.setPayTime(payment.getRequestTime()+10);
			payment.setReceiptUrl("dummyPayment");
			DBService.inputReservationPayment(payment);
		}

	}
	
	private long makeRequestTime() {
		LocalDateTime originalDate = makeReservationClassDate();
		LocalDateTime fiveDaysAgo = originalDate.minusDays(5);
		// UTC 기준 epoch 초(second)로 변환하여 리턴
	    return fiveDaysAgo.toEpochSecond(ZoneOffset.UTC);
	}


	private LocalDateTime makeReservationCom() {
		LocalDateTime originalDate = makeReservationClassDate();
		LocalDateTime fiveDaysAgo = originalDate.minusDays(5);
		return fiveDaysAgo;
	}


	private LocalDateTime makeReservationClassDate() {
		Random random = new Random();

	    // 시작 날짜: 2025-01-01 00:00:00
	    LocalDateTime start = LocalDateTime.of(2020, 1, 1, 0, 0, 0);
	    // 종료 날짜: 2025-07-31 23:59:59
	    LocalDateTime end = LocalDateTime.of(2025, 7, 31, 23, 59, 59);

	    // epochSecond 기준으로 시작과 끝 범위 구함 (UTC 기준)
	    long startEpoch = start.toEpochSecond(ZoneOffset.UTC);
	    long endEpoch = end.toEpochSecond(ZoneOffset.UTC);

	    // 그 사이에서 랜덤 초를 뽑음
	    long randomEpoch = startEpoch + (long) (random.nextDouble() * (endEpoch - startEpoch));

	    // 랜덤 초를 다시 LocalDateTime으로 변환 (UTC 기준)
	    return LocalDateTime.ofEpochSecond(randomEpoch, 0, ZoneOffset.UTC);
	}


		private String selectUserIdx() {
		    String[] userIdxList = {
		        "user20100108074249",
		        "user20100116235622",
		        "user20100226020221",
		        "user20100330042007",
		        "user20100410135157",
		        "user20100423234159",
		        "user20100706133513",
		        "user20100709093517",
		        "user20100925034354",
		        "user20101128111033",
		        "user20101205212945",
		        "user20101208093955",
		        "user20101212050130",
		        "user20110107024739",
		        "user20110117064311",
		        "user20110126053958",
		        "user20110127142238",
		        "user20110225033429",
		        "user20110303191206",
		        "user20110503233827",
		        "user20110518024818",
		        "user20110628142147",
		        "user20110701102402",
		        "user20110711205918",
		        "user20110724191204",
		        "user20110725204738",
		        "user20110804111335",
		        "user20110829082757",
		        "user20110908005418",
		        "user20110918053229",
		        "user20110921034032",
		        "user20111006085356",
		        "user20111015005818",
		        "user20111017201618",
		        "user20111111053752",
		        "user20111121021052",
		        "user20111129044552",
		        "user20111130112432",
		        "user20111221215420",
		        "user20111224101136",
		        "user20120118194612",
		        "user20120130220400",
		        "user20120315181627",
		        "user20120322142645",
		        "user20120405091929",
		        "user20120509020719",
		        "user20120531090053",
		        "user20120618181115",
		        "user20120619031148",
		        "user20120624233328",
		        "user20120708222649",
		        "user20120731002237",
		        "user20120822041855",
		        "user20120828122330",
		        "user20120913123607",
		        "user20120924065449",
		        "user20121012091936",
		        "user20121019173734",
		        "user20121101160859",
		        "user20121124051641",
		        "user20121201165408",
		        "user20121202140805",
		        "user20121214201711",
		        "user20130112185027",
		        "user20130312044949",
		        "user20130313154206",
		        "user20130415162200",
		        "user20130417053146",
		        "user20130426040838",
		        "user20130426220055",
		        "user20130502095957",
		        "user20130524105054",
		        "user20130619204650",
		        "user20130622171037",
		        "user20130713151057",
		        "user20130807174407",
		        "user20130816062856",
		        "user20130906153933",
		        "user20130925013643",
		        "user20130927223132",
		        "user20131003185248",
		        "user20131010063906",
		        "user20131021152412",
		        "user20131124171858",
		        "user20131204014531",
		        "user20131204093752",
		        "user20131211081934",
		        "user20131212093839",
		        "user20131222113055",
		        "user20131230105508",
		        "user20140117203844",
		        "user20140122084021",
		        "user20140125153618",
		        "user20140202041738",
		        "user20140304132641",
		        "user20140310124202",
		        "user20140313170147",
		        "user20140313201006",
		        "user20140318235127",
		        "user20140416060600",
		        "user20140427060302",
		        "user20140522155913",
		        "user20140525180646",
		        "user20140602070251",
		        "user20140701054750",
		        "user20140703020139",
		        "user20140817121305",
		        "user20140820004208",
		        "user20140906163638",
		        "user20140921175730",
		        "user20140926113526",
		        "user20141009133846",
		        "user20141012211715",
		        "user20141013180504",
		        "user20141205021133",
		        "user20141216113146",
		        "user20141221120813",
		        "user20150111110434",
		        "user20150115122237",
		        "user20150205234036",
		        "user20150215231302",
		        "user20150219235055",
		        "user20150224134205",
		        "user20150426193808",
		        "user20150615115936",
		        "user20150708105152",
		        "user20150712160914",
		        "user20150717164423",
		        "user20150718224528",
		        "user20150731130849",
		        "user20150812224822",
		        "user20150817070215",
		        "user20150903015226",
		        "user20150905185631",
		        "user20150917144648",
		        "user20150918050823",
		        "user20150919172337",
		        "user20150925122018",
		        "user20151005054632",
		        "user20151009032256",
		        "user20151015062701",
		        "user20151113190922",
		        "user20151129102040",
		        "user20151130130909",
		        "user20160106044827",
		        "user20160108165141",
		        "user20160111002150",
		        "user20160111113612",
		        "user20160119044727",
		        "user20160202181454",
		        "user20160218103935",
		        "user20160223043209",
		        "user20160304233219",
		        "user20160305003911",
		        "user20160326040459",
		        "user20160414155800",
		        "user20160421163046",
		        "user20160509121658",
		        "user20160614184642",
		        "user20160619233041",
		        "user20160703202830",
		        "user20160709083749",
		        "user20160709214324",
		        "user20160716180201",
		        "user20160726140036",
		        "user20160729201754",
		        "user20160829054430",
		        "user20160920124302",
		        "user20161020063954",
		        "user20161020134313",
		        "user20161020223347",
		        "user20161029195805",
		        "user20161210073842",
		        "user20161224164154",
		        "user20161231070828",
		        "user20170104201711",
		        "user20170124035707",
		        "user20170127060118",
		        "user20170204185617",
		        "user20170226232912",
		        "user20170227192052",
		        "user20170328232215",
		        "user20170401203638",
		        "user20170413104727",
		        "user20170504185801",
		        "user20170518153730",
		        "user20170530023602",
		        "user20170530080433",
		        "user20170607050909",
		        "user20170608113846",
		        "user20170613222035",
		        "user20170625104118",
		        "user20170701212727",
		        "user20170707154927",
		        "user20170817024029",
		        "user20170819191006",
		        "user20170910080723",
		        "user20170926050559",
		        "user20171027210852",
		        "user20171102022950",
		        "user20171104060654",
		        "user20171125184435",
		        "user20171202114136",
		        "user20171212011628",
		        "user20171213102714",
		        "user20171214135821",
		        "user20171230072334",
		        "user20180121052606",
		        "user20180122202951",
		        "user20180206021858",
		        "user20180207225504",
		        "user20180209182928",
		        "user20180301220435",
		        "user20180327185037",
		        "user20180331070819",
		        "user20180501052827",
		        "user20180507174747",
		        "user20180628221259",
		        "user20180711143905",
		        "user20180713212018",
		        "user20180722101020",
		        "user20180805024449",
		        "user20180820012106",
		        "user20180830101802",
		        "user20180903033713",
		        "user20180910114259",
		        "user20180911124501",
		        "user20180919121918",
		        "user20181028142843",
		        "user20181103200634",
		        "user20181107060617",
		        "user20181118011247",
		        "user20181212183756",
		        "user20181220193042",
		        "user20190223125735",
		        "user20190225224119",
		        "user20190305001504",
		        "user20190306085340",
		        "user20190319204503",
		        "user20190327214435",
		        "user20190406012644",
		        "user20190418061558",
		        "user20190506154113",
		        "user20190608123215",
		        "user20190821115731",
		        "user20190903113510",
		        "user20190907205742",
		        "user20190912181418",
		        "user20191103050634",
		        "user20191117230306",
		        "user20191123092603",
		        "user20191124060845",
		        "user20191129090735",
		        "user20191220210647",
		        "user20191225212418",
		        "user20191227033827",
		        "user20191229231328",
		        "user20200208181133",
		        "user20200213081353",
		        "user20200215000046",
		        "user20200223181139",
		        "user20200224181247",
		        "user20200312215441",
		        "user20200315181757",
		        "user20200505040844",
		        "user20200512232829",
		        "user20200516204846",
		        "user20200529192826",
		        "user20200530213849",
		        "user20200607234833",
		        "user20200609004133",
		        "user20200702022322",
		        "user20200706035609",
		        "user20200709221211",
		        "user20200718045755",
		        "user20200719004037",
		        "user20200811162650",
		        "user20200904002843",
		        "user20200905091240",
		        "user20200906155907",
		        "user20200916223712",
		        "user20200921064506",
		        "user20201012055439",
		        "user20201026200012",
		        "user20201105185038",
		        "user20201114015726",
		        "user20201229165327",
		        "user20210125210456",
		        "user20210201070707",
		        "user20210202054026",
		        "user20210206212540",
		        "user20210222111433",
		        "user20210303221137",
		        "user20210422163830",
		        "user20210428224142",
		        "user20210501230517",
		        "user20210502132559",
		        "user20210517065131",
		        "user20210612193042",
		        "user20210627162921",
		        "user20210723165013",
		        "user20210810093705",
		        "user20210902111151",
		        "user20210926093013",
		        "user20211002040251",
		        "user20211002121135",
		        "user20211003145942",
		        "user20211108154054",
		        "user20211110124931",
		        "user20211110160549",
		        "user20211126070104",
		        "user20211128125523",
		        "user20211130041731",
		        "user20211202051652",
		        "user20211202111109",
		        "user20220102231347",
		        "user20220109073124",
		        "user20220131030250",
		        "user20220210024123",
		        "user20220217203102",
		        "user20220220093349",
		        "user20220319053051",
		        "user20220507145303",
		        "user20220526043107",
		        "user20220530090103",
		        "user20220608203044",
		        "user20220722130905",
		        "user20220805134947",
		        "user20220810065924",
		        "user20220820014554",
		        "user20220917090146",
		        "user20221029072934",
		        "user20221106060105",
		        "user20221203220759",
		        "user20221209005030",
		        "user20230104095201",
		        "user20230105054045",
		        "user20230219164505",
		        "user20230221092856",
		        "user20230301132316",
		        "user20230308222112",
		        "user20230310063842",
		        "user20230318153204",
		        "user20230325085023",
		        "user20230329171912",
		        "user20230413094608",
		        "user20230527022704",
		        "user20230607014020",
		        "user20230701172010",
		        "user20230709043359",
		        "user20230711143925",
		        "user20230802204724",
		        "user20230819122218",
		        "user20230923034331",
		        "user20231003235457",
		        "user20231103222817",
		        "user20231107190956",
		        "user20240105115533",
		        "user20240118005508",
		        "user20240202075412",
		        "user20240217083407",
		        "user20240219151444",
		        "user20240222121032",
		        "user20240317203948",
		        "user20240406114952",
		        "user20240414064542",
		        "user20240415025856",
		        "user20240421012321",
		        "user20240617123219",
		        "user20240710010927",
		        "user20240717173509",
		        "user20240817174030",
		        "user20240828031151",
		        "user20240829122812",
		        "user20240831212740",
		        "user20240920174015",
		        "user20241007110530",
		        "user20241012084233",
		        "user20241020234254",
		        "user20241106102434",
		        "user20241216032226",
		        "user20241217182233",
		        "user20241222181624",
		        "user20241231040649",
		        "user20250101134658",
		        "user20250109192233",
		        "user20250125172536",
		        "user20250127084750",
		        "user20250216023642",
		        "user20250309032955",
		        "user20250412075659",
		        "user20250509224027",
		        "user20250512083936",
		        "user20250512154921",
		        "user20250529180607",
		        "user20250531111619",
		        "user20250706092854",
		        "user20250726092649",
		        "user20250806141145",
		        "user20250806152743",
		        "user20250806162143",
		        "user20250806165858",
		        "user20250807015927",
		        "user20250828113147"
		    };

		    Random random = new Random();
		    int randomIndex = random.nextInt(userIdxList.length);
		    return userIdxList[randomIndex];
		}
	
	private BigDecimal makeRandomAmount() {
	    Random random = new Random();

	    // 1 ~ 5 사이의 정수 랜덤 생성
	    int multiplier = random.nextInt(5) + 1; 

	    // 10,000원 단위로 계산
	    BigDecimal amount = BigDecimal.valueOf(multiplier).multiply(BigDecimal.valueOf(10000));

	    return amount;
	}


	private String selectClassIdx() {
		String[] classTitles = {
		        "CLSFAKEDATA"
		    };

		    Random random = new Random();
		    int idx = random.nextInt(classTitles.length);
		    return classTitles[idx];
	}


	private String makeRandomResrvationIdx() {
		Random random = new Random();

	    // 시작 날짜 (임의) : 2010-01-01 00:00:00 예시 (필요시 변경 가능)
	    LocalDateTime start = LocalDateTime.of(2010, 1, 1, 0, 0, 0);

	    // 종료 날짜 : 2025-08-05 23:59:59
	    LocalDateTime end = LocalDateTime.of(2025, 8, 5, 23, 59, 59);

	    // 시작과 끝 시간의 epoch-second 구하기 (UTC 기준)
	    long startEpoch = start.toEpochSecond(ZoneOffset.UTC);
	    long endEpoch = end.toEpochSecond(ZoneOffset.UTC);

	    // 랜덤 초 생성
	    long randomEpoch = startEpoch + (long)(random.nextDouble() * (endEpoch - startEpoch));

	    // epoch-second → LocalDateTime 변환
	    LocalDateTime randomDateTime = LocalDateTime.ofEpochSecond(randomEpoch, 0, ZoneOffset.UTC);

	    // 날짜 시간 포맷팅 (yyyyMMddHHmmss)
	    String dateStr = randomDateTime.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

	    // 난수 생성 (예: 두 자리 숫자 00~99)
	    int randNum = random.nextInt(100); 
	    String randStr = String.format("%02d", randNum);

	    // 최종 문자열 생성
	    return "RE" + dateStr + randStr;
	}


	private String makeRandomimpUid() {
		Random random = new Random();

	    // 12자리 숫자 생성 (0부터 999999999999 사이)
	    // long 범위까지 커버 가능하므로 long 사용해도 됨
	    long number = (long)(random.nextDouble() * 1_000_000_000_000L);

	    // 12자리 숫자 형식 맞추기 (앞에 0 패딩)
	    String numberStr = String.format("%012d", number);

	    return "imp_t" + numberStr;
	}
	
	
	
	
	
	
	
	
	
	
	
}
