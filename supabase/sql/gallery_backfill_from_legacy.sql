
-- Generated from data/gallery_migration/gallery-data.json
create temporary table tmp_gallery_legacy (
  id text,
  source_idx text,
  source_present_num text,
  title text,
  content text,
  author text,
  date_text text,
  source_url text,
  source_letter_no text,
  list_page_num integer,
  thumbnail_url text
) on commit drop;

insert into tmp_gallery_legacy (id, source_idx, source_present_num, title, content, author, date_text, source_url, source_letter_no, list_page_num, thumbnail_url)
values
('995','995','223','2026 전기 졸업식','2월 23,24일 윤정 누나와 윤지, ASL 새 멤버 조영흠 학생의 졸업식이 있었습니다.

모두 졸업 축하드립니다~~','관리자','03-05','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk5NSZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjIz||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21772694202.png'),
('988','988','222','2025 송년회','2025 ASL 결산

2025년도 연말을 맞아 송년회를 하였습니다.

ASL을 졸업하신 많은 선배님들께서 참석해주셔서 즐거운 시간을 보냈습니다.

참석해주신 모든 분들께 진심으로 감사드립니다!

2025 ASL 결산 영상도 많은 시청 부탁드립니다~','관리자','12-16','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4OCZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjIy||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21765866918.png'),
('987','987','221','2025 ICAVS13','2025년 11월 30일 ~ 12월 5일

중국 Xiamen 에서 열린 ICAVS13 학회에 교수님, 부이투투이, 정해성, 김준희 학생이 참가했습니다.

교수님과 부이투투이, 정해성 학생이 구두발표를 하였고,

학회 점심시간을 이용해 Xiamen의 명물이라는 사챠면도 먹어봤습니다 🤤','관리자','12-09','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4NyZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjIx||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21765253286.png'),
('985','985','220','2025 후기 졸업식','8월 21일 투이언니와 상훈 오빠, ASL 새 멤버 김준희 학생의 졸업식이 있었습니다.

모두 졸업 축하드립니다~~','관리자','10-21','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4NSZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjIw||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21761010521.png'),
('982','982','219','The 13th International Symposium on Two-dimensional Correlation Spectroscopy (2DCOS-XIII)','2025년 8월

17일부터 8월 19일까지

Peking University에서 열린

2DCOS-XIII에

정회일 교수님, 조지우, 김윤지 학생이 참가하여 구두 발표를 진행하였습니다.','관리자','08-20','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4MiZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE5||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21755656333.jpg'),
('981','981','218','2025 ICML','2025년 7월 13~19일

캐나다 밴쿠버 도시에서 열린 ICML 학회에

교수님과 정성수 학생이 참가하였습니다.

이후 밴쿠버 도시와 휘슬러 구경도 하였습니다.','관리자','07-23','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4MSZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE4||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21753263056.jpg'),
('980','980','217','2025 스승의날','2025년 5월 9일 스승의날 행사가 열렸습니다.

ASL 인턴부터 졸업하신 선배님들까지 많은 분들께서 참석하여 즐거운 식사시간을 가졌습니다.

바쁜 가운데 시간내어 참석해주신 모든 분들께 감사의 인사 전합니다.

그리고 늘 아낌없는 관심과 따뜻한 애정을 보내주시는 정회일 교수님께도 깊이 감사드립니다.

ASL 파이팅!','관리자','05-16','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4MCZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE3||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21747382602.png'),
('978','978','216','2025 춘계 대한화학회','2025년 4월 23일부터 4월 25일까지

수원 컨벤션센터에서 열린 춘계 대한화학회에

조지우, 김윤지 학생이 참가하여 구두 발표를 진행하였습니다.

또한, 정회일 교수님께서는

2024년도 대한화학회 분석화학분과회 회장으로서

학회 발전과 회원 간 친목에 기여한 공로로 공로상을 수상하셨습니다.','관리자','04-29','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk3OCZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE2||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21745892462.jpg'),
('977','977','215','ANS-2024 (9th Asian NIR Symposium)','2024년 12월 8일부터 12월 10일까지 인도 콜카타에서 열린 9th Asian NIR Symposium에

조지우, 김윤지 학생이 참가하여 구두 발표를 진행하였습니다.

교수님께서는 한국에서 Zoom으로 참가하셨습니다.

교수님과 함께하지 못해 아쉽기도 했지만

많은 것을 배울 수 있었던 뜻깊은 학회였습니다.','관리자','03-15','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk3NyZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE1||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21742016807.png'),
('976','976','214','2024 송년회','2024 ASL 결산

연말을 맞아 저녁식사를 하였습니다.

ASL을 졸업하신 많은 선배님들께서 참석해주셔서 즐거운 시간을 보냈습니다.

참석해주신 모든 분들께 감사의 인사 전해드립니다.

2024 ASL 결산 영상도 많은 시청 부탁드립니다~','관리자','03-15','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk3NiZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE0||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21742015823.jpg'),
('963','963','213','2024 SciX (2)','North Carolina 주 Raleigh 에서 열린 2024 Scix 학회에 교수님, 정해성, 김상재 학생이 참가하였습니다.

교수님께서는 총 두번의 구두발표를 하셨고, 김상재 학생은 포스터 발표를 하였습니다.

학회 일정을 마친 후 Richmond에 위치한 Altria 회사와 업무미팅을 가졌습니다.

오프라인으로 약 20명, 온라인으로 약 50명의 인원이 미팅에 참가할 정도로 높은 관심을 보여줬습니다!

미팅일정까지 마무리 된 뒤, 박석찬♡김민정 박사님 댁에서 맛있는 저녁도 먹었답니다 :)','관리자','10-31','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk2MyZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjEz||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21730340389.jpg'),
('962','962','212','2024 SciX (1)','North Carolina 주 Raleigh 에서 열린 2024 SciX 학회에 교수님, 정해성, 김상재 학생이 참가하였습니다.

교수님과 정해성 학생이 구두발표를 하였습니다.

숙소 테라스에서 교수님께서 구워주셨던 스테이크 맛이 아직도 잊혀지지 않네요 :)','관리자','10-31','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk2MiZwYWdlY250PTAmbGV0dGVyX25vPTIyMyZvZmZzZXQ9MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjEy||&boardIndex=2&sub=1&gubun=','223',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21730339844.jpg'),
('955','955','211','2024 XIX CAC','2024년 9월 9~12일

아르헨티나 산타페 도시에서 열린 XIX CAC 학회에

교수님, 정성수 학생이 참가하였습니다.

정성수 학생의 구두 발표가 진행되었습니다.

이후 이과수 폭포 구경도 하였습니다.','관리자','09-19','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk1NSZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIxMQ==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21726732063.jpg'),
('952','952','210','2024 분석화학/전기화학분과 하계 합동심포지엄','국립목포대학교에서 개최된 2024 대한화학회 분석화학/전기화학분과 하계 합동심포지엄이

분석화학 분과회장인 정회일교수님의 주도하에 개최되었습니다.

연구실 모든 학생들이 참석하여 행사 진행에 도움을 드렸습니다.

조상훈 학생이 구두발표, Thuy, 조지우 학생이 포스터 발표를 진행하였습니다.

또한, 연구실 선배이신 이영복, 김재진, Huan 박사님들도 참석하셨습니다.','관리자','07-02','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk1MiZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIxMA==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21719886266.png'),
('946','946','209','2024 춘계 한국분석과학회','강릉 세인트존스 호텔에서 열린 2024년 제 72회 분석과학회에

정회일 교수님과 김윤정, 김상재, 김윤지 학생이 참가하여 구두 및 포스터 발표를 진행하였습니다.','관리자','05-31','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk0NiZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwOQ==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21717121065.png'),
('943','943','208','2024 스승의 날','스승의 날을 맞아 저녁식사를 하였습니다.

ASL을 졸업하신 많은 선배님들께서 참석해주셔서 즐거운 시간을 보냈습니다.

참석해주신 모든 분들께 감사의 인사 전합니다.

그리고 항상 무한한 관심과 애정을 주시는 정회일 교수님께도 진심으로 감사드립니다.

ASL 파이팅!','관리자','05-11','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk0MyZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwOA==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21715403729.png'),
('942','942','207','2024 춘계 대한화학회','수원 컨벤션센터에서 열린 2024년 춘계 대한화학회에 교수님과 정해성, 정성수, 박주영 학생이 참가하였습니다.','관리자','04-29','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk0MiZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwNw==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21714363134.jpg'),
('939','939','206','2023 GYSS','김윤정 학생이 선발되어

싱가포르에서 개최된

2023 GYSS 학회에 참석하였습니다.

다양한 분야에서 종사하는 연구자들, 연사분들과

많은 얘기를 나눌 수 있어

관심 연구분야를 확대할 수 있는 좋은 기회였습니다.','관리자','02-13','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkzOSZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwNg==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21707816077.jpg'),
('937','937','205','2023 추계 대한화학회','광주 김대중컨벤션센터에서 열린 2023년 추계 대한화학회에 교수님과 정해성, 김상재 학생이 참가하였습니다.','관리자','11-02','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkzNyZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwNQ==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21698886498.jpg'),
('935','935','204','2023 제44회 한국법과학회 추계학술대회','제44회 한국법과학회 추계학술대회에 교수님과 정성수 학생, 학부생 방효주, 박지원 학생이 참여하였습니다.

정성수 학생이 우수 구연발표상을 수상하였습니다.','관리자','10-28','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkzNSZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwNA==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21698466634.png'),
('932','932','203','2023 SCIX','2023년 10월

미국 리노에서 열린 SCIX학회에

교수님, 조상훈, 김윤정 학생이 참석하였습니다.

연구실 선배이신 박석찬 박사님도 참석하시어 많은 얘기 함께 나눴습니다~

교수님, 조상훈, 김윤정 학생의 발표가 진행되었습니다.

근처 시내도 돌아보고 타호 호도 구경하며 즐거운 시간 보냈습니다.','관리자','10-18','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkzMiZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwMw==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21697603541.png'),
('925','925','202','2023 전기분석화학분과 하계 심포지엄','2023 대한화학회 전기분석화학분과 하계 합동심포지엄에 교수님과 연구실 전원이 참석하였습니다.

학부생 윤지, 주영이도 참석하였습니다~

정성수 학생이 우수 구두발표, 김윤정학생이 우수포스터상을 수상하였습니다.

축하합니다.','관리자','07-08','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkyNSZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwMg==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21688797768.png'),
('922','922','201','2023 스승의날','스승의날 맞이 저녁식사 하였습니다.

예정되어있던 등산을 하기 위해 생수병 라벨지, 슬로건, 깃발을 제작하였으나

일정에 변동이 생겨 사진으로라도 남겼습니다.

감사합니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkyMiZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwMQ==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21688551007.png'),
('916','916','200','2023 PITTCON','2023년 3월 18~22일

미국 필라델피아에서 열린 PITTCON 학회에

교수님, 정성수, 정해성 학생이 참가하였습니다.

정성수, 정해성 학생의 구두 발표가 진행되었습니다.

이후 시내와 교외 구경도 하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkxNiZwYWdlY250PTAmbGV0dGVyX25vPTIxMSZvZmZzZXQ9MTImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTIwMA==||&boardIndex=2&sub=1&gubun=','211',2,'http://asl.hanyang.ac.kr/upload/bbs/a_img21679976893.jpg'),
('915','915','199','2022 송년회','2022 송년회 맞이 저녁식사 하였습니다.

ASL 멤버들과 많은 선배님들께서 참석하여 자리를 빛내주셨습니다.

모두 2022년 한해동안 고생 많으셨습니다.

감사합니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkxNSZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5OQ==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21672206556.png'),
('909','909','198','2022 추계 대한화학회','2022 10월에 경주에서 열린 추계 대한화학회에

김윤정, 김상재 학생이 참석하여

구두발표와 포스터발표를 하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkwOSZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5OA==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21666592911.png'),
('908','908','197','2022 SCIX','2022년 10월

미국 신시내티에서 열린 SCIX학회에

교수님, 조상훈, 김윤정 학생이 참석하였습니다.

조상훈 학생의 구두발표와 김윤정 학생의 포스터 발표가 진행되었습니다.

이후 교수님께서 직접 고기를 구워주시고 시내도 구경하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkwOCZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5Nw==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21666592685.png'),
('907','907','196','2022 SPEC','2022년 6월

아일랜드 더블린에서 열린 SPEC 학회에

교수님, 송우석, 장은진, Thuy 학생이 참석하여

포스터발표를 하였습니다.

경유지인 네덜란드도 방문하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkwNyZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5Ng==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21666592281.png'),
('905','905','195','2022 후기 졸업식','8/18 은진누나와 은아누나의 졸업식이 있었습니다.

졸업 축하드립니다~~​','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkwNSZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5NQ==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21666590516.jpg'),
('896','896','194','2022 스승의날','스승의날 맞이 저녁식사 하였습니다.

교수님의 한양대학교 화학과 재직 20주년을 기념하여

많은 선배님, 재학생, 학부생들이 참석하여 자리를 빛내주셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg5NiZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5NA==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21653550108.jpg'),
('886','886','193','2022 스승의날','스승의날 맞이 저녁식사 하였습니다.

교수님의 한양대학교 화학과 재직 20주년을 기념하여

많은 선배님, 재학생, 학부생들이 참석하여 자리를 빛내주셨습니다.

커스텀 소주잔 뽑기 이벤트도 진행하였습니다^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg4NiZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5Mw==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21653104600.jpg'),
('884','884','192','2022 춘계 대한화학회','2022 4월에 제주도에서 열린 춘계 대한화학회에 설다운, 장은진, 송우석, 조상훈, 김윤정, Thuy, 정해성, 정성수가 참석하였습니다. ​','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg4NCZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5Mg==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21651663766.jpg'),
('883','883','191','2022 춘계 대한화학회','2022 4월에 제주도에서 열린 춘계 대한화학회에 설다운, 장은진, 송우석, 조상훈, 김윤정, Thuy, 정해성, 정성수가 참석하였습니다. ​

정해성 학생은 동우화인켐 최우수포스터상을 수상하였습니다.

조상훈 학생은 대한화학회 분석화학 우수 구두발표상을 수상하였습니다.

축하드립니다~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg4MyZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5MQ==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21651663699.jpg'),
('880','880','190','2022 졸업식','2/18 창환이형과 윤정누나의 졸업식이 있었습니다.

졸업 축하드립니다~~​','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg4MCZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE5MA==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21645445790.jpg'),
('876','876','189','2021 추계 대한화학회','2021 10월에서 부산에서 열린 추계 대한화학회에 김윤정, Thuy, 정해성, 정성수가 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg3NiZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4OQ==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21640237667.png'),
('867','867','188','2020 분석과학회','2020년 6월 여수에서 열린 64회 한국분석과학회 하계 학술대회에

윤정, 은진, 우석, thuy가 참여하였습니다

은진이는 63회 추계 학술대회 때 발표한 내용으로 우수 구두발표상을 받았습니다~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg2NyZwYWdlY250PTAmbGV0dGVyX25vPTE5OSZvZmZzZXQ9MjQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4OA==||&boardIndex=2&sub=1&gubun=','199',3,'http://asl.hanyang.ac.kr/upload/bbs/a_img21626172583.jpg'),
('866','866','187','2021 5,6월 생일축하파티','연구실에서 5월 생일자 음창환, 이윤정, 남경민, 6월 생일자 송우석의 생일파티를 하였습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg2NiZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4Nw==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21625806304.gif'),
('857','857','186','2021 졸업식','2021 졸업식','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg1NyZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4Ng==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21617870922.jpg'),
('818','818','185','2020 스승의날','스승의날 맞이 저녁식사 하였습니다

남궁한규, 이상욱, 김샛별, 장결 선배님 참석해주셨습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTgxOCZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4NQ==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21589778140.png'),
('782','782','184','2020 PITTCON','3. 1-5

미국 시카고에서 열린

PITTCON

창환, 윤정 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc4MiZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4NA==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584444267.png'),
('781','781','183','2020 ANS','2. 12-15

태국 콘캔에서 열린

ANS 학회

우석, 은진, 상훈

참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc4MSZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4Mw==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584443992.png'),
('780','780','182','2019 분석과학회','11. 14-15

제주도 부영호텔에서 열린

상훈, 은진, 창환 다녀왔습니다.

창환이 형이 수상하셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc4MCZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4Mg==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584443718.png'),
('779','779','181','2019 ISPFM','11. 6-7

인도네시아 발리에서 열린

ISPFM 에 참석하셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc3OSZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4MQ==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584443518.jpg'),
('778','778','180','2019 SciX','10. 13-18

미국 캘리포니아주

팜 스프링스에서 열린

SciX 참석하였습니다

차경준 교수님도 함께 해주셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc3OCZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE4MA==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584443376.png'),
('777','777','179','2019 졸업식','다운누나의 졸업식이 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc3NyZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3OQ==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584443101.jpg'),
('776','776','178','2019 2DCOS','8. 19-21

중국 길림성 길림대학교에서

학회가 있었습니다.

오붓하게 다녀왔습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc3NiZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3OA==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584442876.png'),
('775','775','177','2019 Aqouaphotomics','7.21-23

중국 진안에서

Aqouaphotomics 학회가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc3NSZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3Nw==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21584442777.jpg'),
('729','729','176','2019 전기/분석분과회 심포지엄','2019. 06.27 ~ 2019.06.28

분석분과회 심포지엄을 다녀왔습니다!

ASL의 모든 학생들이 다같이 무창포를 다녀왔습니다

신비의 바닷길도 보고 소라게도 잡으며 즐거운 시간을 보냈습니다~~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcyOSZwYWdlY250PTAmbGV0dGVyX25vPTE4NyZvZmZzZXQ9MzYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3Ng==||&boardIndex=2&sub=1&gubun=','187',4,'http://asl.hanyang.ac.kr/upload/bbs/a_img21562054513.jpg'),
('728','728','175','2019 돌잔치및 환송회','2019.06.15

ASL에서 7년을 함께한 Duy의 환송회가 있었습니다

또한 Duy의 첫째인 오이의 돌잔치도 함께하였습니다!

날씨도 duy의 새로운 출발과 오이의 첫생일을 축하하는지 구름도 예쁜 날이었습니다 ^.^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcyOCZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3NQ==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21562054308.jpg'),
('727','727','174','2019 분석과학회','2019.05.16 ~ 2019.05.17

강릉에서 열린 분석과학회에

창환, 윤정, 우석이 다녀왔습니다!

오랜만에 바다를 보고 돌아왔습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcyNyZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3NA==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21562053749.jpg'),
('726','726','173','2019 스승의날','2019.05.15

스승의날을 맞아 다함께 저녁식사를 하였습니다~

교수님 항상 감사합니다~!~!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcyNiZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3Mw==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21562053566.jpg'),
('725','725','172','2019 춘계 대한화학회','2019.04.17 ~ 2019.04.19

수원에서 열린 대한화학회에 Tung, 은진, 상훈이 참여하였습니다~

이영복교수님께서 젊은분석화학자상을 수상하셨습니다! 축하드립니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcyNSZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3Mg==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21562053449.jpg'),
('707','707','171','The First Advanced Petrochemical Analytical Technology International Forum','June 18-20, 2019 in Beijing, China

교수님께서 Invited speaker로 다녀오셨습니다~!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcwNyZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3MQ==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21561185264.jpg'),
('675','675','170','2019 점심 식사','카자흐스탄으로 돌아가는 Merey 와 새롭게 인도네시아에서 온

Devi 까지 커리야에서 다 같이 점심 식사 했습니다

̴̶̷̣̥̀','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY3NSZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE3MA==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21554117373.png'),
('674','674','169','2019 등나무에서','봄이 다가 오네요

̴̶̷̤́ ‧̫̮','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY3NCZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2OQ==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21554117104.jpg'),
('661','661','168','2019 회식','카자흐스탄에서 온 Merey 와 함께 우즈베키스탄 레스토랑 ''Samarkand City'' 에서 회식 했습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY2MSZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2OA==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21552544594.png'),
('654','654','167','2018 학부생 졸업 논문 발표회','2018.11.16

화학과 4학년 졸업 논문 발표회가 있었습니다

세혁, 선웅, 철민, 가희가 포스터 발표를 잘 마쳤습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY1NCZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2Nw==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21552354254.jpg'),
('643','643','166','2018 송년회','2018.12.15

청담에서 ASL 멤버와 졸업생분들과 함께 즐거운 송년회를 보냈습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY0MyZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2Ng==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21548744949.png'),
('641','641','165','2018 송년회','2018.12.15

청담에서 ASL 멤버와 졸업생 함께 즐거운 송년회를 보냈습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY0MSZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2NQ==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21546559477.jpg'),
('640','640','164','2018 분석과학회','2018.11.15 - 11.16

거제에서 열린 분석과학회에 교수님, Tung, 상훈이 참석하였습니다

Tung은 제60회 춘계 학술대회에서 발표한 논문으로 우수 구두 발표 상을 받았습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY0MCZwYWdlY250PTAmbGV0dGVyX25vPTE3NSZvZmZzZXQ9NDgmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2NA==||&boardIndex=2&sub=1&gubun=','175',5,'http://asl.hanyang.ac.kr/upload/bbs/a_img21546559272.jpg'),
('636','636','163','2018 Nanopia','2018.11.07 - 11.09

창원에서 열린 나노피아에 ASL 멤버 모두 참석하였습니다

ASL 멤버와 인턴 Ayi도 다같이 사진을 찍었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYzNiZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2Mw==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21545196630.jpg'),
('635','635','162','2018 Nanopia','2018.11.07 - 11.09

창원에서 열린 나노피아에 ASL 멤버 모두 참석하였습니다

Duy, 다운, 은진, 우석의 포스터 발표가 있었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYzNSZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2Mg==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21545196602.jpg'),
('634','634','161','2018 SCIX','2018 SCIX Atlanta USA

2018.10.21 -26

2018 SCIX에 교수님께서 참석하셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYzNCZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2MQ==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21564373139.jpg'),
('621','621','160','2018 KCS','2018 대한화학회 대구 exco

2018.10.17 -19

대구 대한화학회에 두이오빠와 우석이가 다녀왔습니다

두이오빠의 구두 발표와 우석이의 구두발표 및 포스터 발표가 있었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYyMSZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE2MA==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21540275032.jpg'),
('620','620','159','2018 CSD','2018. 09. 10-11

하노이에서 열린 CSD 학회에

교수님께서 다녀오셨습니다.

10일에는 교수님의 구두발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYyMCZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1OQ==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21540258106.jpg'),
('619','619','158','2018 ICORS','2018. 08. 26 -31

제주도에서 열린 ICORS 학회에

Tung, 윤정, 은진이 다녀왔습니다.

30일에는 교수님의 구두발표가 있었습니다.

31일에는 졸업한 선배들과 같이 스태프 복장을 입고 기념사진을 찍었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYxOSZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1OA==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21540257787.jpg'),
('618','618','157','2018 ICORS','2018. 08. 26 -31

제주도에서 열린 ICORS 학회에

Tung, 윤정, 은진이 다녀왔습니다.

27일에는 윤정, 은진의 포스터 발표와

28일에는 Tung의 구두발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYxOCZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1Nw==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21540257380.jpg'),
('613','613','156','2018 졸업식','2018.08.17

장결 박사와 조상훈 학생의 졸업식이 있었습니다.

모두 축하합니다 ~ ~ ~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYxMyZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1Ng==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21537183698.jpg'),
('605','605','155','2018 ANS','2018. 6. 21-25

중국 쿤밍에서 열린 ANS 학회에

윤정, 은진, 우석, 상훈이 다녀왔습니다

쿤밍에서 즐거운 시간을 보냈습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYwNSZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1NQ==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21529908883.png'),
('604','604','154','2018 ANS','2018. 6. 21-25

중국 쿤밍에서 열린 ANS 학회에

윤정, 은진, 우석, 상훈이 다녀왔습니다

23일에는 우석이의 포스터발표와 은진이의 구두발표가 있었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYwNCZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1NA==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21529908762.png'),
('603','603','153','2018 ANS','2018. 6. 21-25

중국 쿤밍에서 열린 ANS 학회에

윤정, 은진, 우석, 상훈이 다녀왔습니다

22일에는 윤정, 상훈의 포스터발표가 있었습니다

윤정이는 우수포스터상을 받았습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYwMyZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1Mw==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21529908559.png'),
('602','602','152','2018 분석과학회','2018. 05. 17

경주에서 열린 2018 분석과학회를

교수님, 텅, 창환이 다녀왔습니다.

이번 년도는 분석과학회 30주년을 맞이하여 교수님께서 ''영인분석과학자상''을 받으셨습니다.

교수님 축하드립니다!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYwMiZwYWdlY250PTEmbGV0dGVyX25vPTE2MyZvZmZzZXQ9NjAmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1Mg==||&boardIndex=2&sub=1&gubun=','163',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21529403881.jpg'),
('601','601','151','2018 스승의날','2018. 5. 11

스승의 날을 맞아 저녁을 함께 하였습니다

교수님 항상 감사드립니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYwMSZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1MQ==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21529387957.jpg'),
('585','585','150','2018 인도네시아 세미나','2018. 05. 04

University of Indonesia 에서

교수님께서 세미나를 하셨습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU4NSZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE1MA==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21525417325.gif'),
('556','556','149','2018 졸업식','2018.02.22 ~2018.02.23

동현, 리합, 우석 졸업식이 있었습니다

졸업 축하드립니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU1NiZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0OQ==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21519440127.png'),
('548','548','148','2017- ABB MOU','2017- ABB MOU','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0OCZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0OA==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21513053133.jpg'),
('546','546','147','2017 산학협력 체결식','17/11/29

ABB 회사와 산학협력 체결식을 진행하였습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0NiZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0Nw==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21513052892.jpg'),
('544','544','146','2017 HPLC','제주도에서 열린 HPLC 학회에

다운, 윤정이 참석하였습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0NCZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0Ng==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21511945446.png'),
('543','543','145','2017 SCIX','미국 리노에서 열린 SCIX 학회에

교수님, 다운, 창환, Tung이 다녀왔습니다

학회가 끝난 후에는 국립공원도 방문하였습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0MyZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0NQ==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21511945374.png'),
('542','542','144','2017 SCIX','미국 리노에서 열린 SCIX 학회에

교수님, 다운, 창환, Tung이 다녀왔습니다

다운, 창환의 포스터발표,

Tung의 oral발표가 있었습니다

또 내년에 분석화학 교수님으로 오시는 김두리 교수님을 뵙고자

University of california at berkeley 를 방문하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0MiZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0NA==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21511945201.png'),
('541','541','143','2017 치앙마이 세미나','태국 치앙마이 실리피콘 대학에서

교수님께서 세미나를 하셨습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0MSZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0Mw==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21511943068.png'),
('500','500','142','2017 스승의날','2017 / 5 / 10

스승의 날을 맞아 다 같이 저녁을 먹었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTUwMCZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0Mg==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499153690.jpg'),
('499','499','141','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

유익하고 재미있는 시간을 보내고 왔습니다~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5OSZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0MQ==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499131873.jpg'),
('498','498','140','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

학회가 끝나고 간단한 저녁식사를 먹었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5OCZwYWdlY250PTEmbGV0dGVyX25vPTE1MSZvZmZzZXQ9NzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTE0MA==||&boardIndex=2&sub=1&gubun=','151',7,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499131799.jpg'),
('497','497','139','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

항몽유적지에서 단체 사진을 찍었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5NyZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzOQ==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499131536.jpg'),
('496','496','138','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

항몽유적지에서 단체 사진을 찍었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5NiZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzOA==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499131497.jpg'),
('495','495','137','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

동현, 창환이 포스터 앞에서 사진을 찍었습니다 ^^

창환이는 우수 포스터 상을 받았습니다 ~~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5NSZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzNw==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499131210.jpg'),
('494','494','136','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

두이, 결이 포스터 앞에서 사진을 찍었습니다 ^^7','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5NCZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzNg==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499131142.jpg'),
('493','493','135','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

숙소 근처 치맥집에서 다같이 사진을 찍었습니다~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5MyZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzNQ==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499085291.jpg'),
('492','492','134','2017 하계분석분과회','2017.06.29 ~ 2017.06.30

제주도에서 열린 하계분석분과회에 다녀왔습니다.

학회장에서 다같이 사진을 찍었습니다~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5MiZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzNA==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499085159.jpg'),
('489','489','133','2017 NBSIS','2017.02.22 ~ 2017.02.24

2017 NBSIS 학회에

교수님, 다운, 윤정, 텅이 다녀왔습니다.

둘째날(02.23)에는 교수님께서

oral presentation를 하셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ4OSZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzMw==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21499084781.jpg'),
('484','484','132','2017 대한화학회 KCS','2017.04.19 ~ 04.21

일산킨텍스로 대한화학회를 다녀왔습니다.

4/20에는 교수님의 심포지엄 구두발표가 있었습니다.

4/21에는 음창환 학생의 구두발표 및 포스터발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ4NCZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzMg==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21493179392.png'),
('469','469','131','2017 졸업식','2017.02.16 ~ 2017.02.17

은진, 슬아, 두이의 졸업식이 있었습니다

모두모두 축하합니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2OSZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzMQ==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21487322576.jpg'),
('468','468','130','2016 송년회','2016.12.17

2016년을 마무리하며 ASL 송년회를 했습니다 ^^

ASL 멤버들 모두 즐거운 시간을 보냈습니다~

참석해주신 선배님들 너무 감사합니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2OCZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEzMA==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21482220203.jpg'),
('467','467','129','2016 송년회','2016.12.17

2016년을 마무리하며 ASL 송년회를 했습니다 ^^

선배님들도 오셔서 즐거운 시간을 보냈습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2NyZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyOQ==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21482219695.jpg'),
('466','466','128','2016 송년회','2016.12.17

2016년을 마무리하며 ASL 송년회를 했습니다 ^^

방장 결이가 ASL멤버들 소개 및 올해 연구실 업적발표를 했습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2NiZwYWdlY250PTEmbGV0dGVyX25vPTEzOSZvZmZzZXQ9ODQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyOA==||&boardIndex=2&sub=1&gubun=','139',8,'http://asl.hanyang.ac.kr/upload/bbs/a_img21482219534.jpg'),
('465','465','127','2016 송년회','2016.12.17

2016년을 마무리하며 ASL 송년회를 했습니다 ^^

다가오는 2017년을 위해 다같이 초를 불었습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2NSZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyNw==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21482219379.jpg'),
('464','464','126','2016 송년회','2016.12.17

송년회에 온 리합언니 딸들과 사진을 찍었습니다~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2NCZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyNg==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21482219133.jpg'),
('463','463','125','2016 송년회','2016.12.17

2016년을 마무리하며 ASL 송년회를 했습니다 ^^

선배님들도 오셔서 즐거운 시간을 보냈습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2MyZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyNQ==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21482218866.jpg'),
('461','461','124','2016 ANS','2016.11.30 ~ 2016.12.04

일본 가고시마

ANS2016 학회에

교수님, 결, 다운, 동현, 창환, 윤정이 다녀왔습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2MSZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyNA==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481891625.jpg'),
('460','460','123','2016 ANS','2016.11.30 ~ 2016.12.04

일본 가고시마

ANS2016 학회에

교수님, 결, 다운, 동현, 창환, 윤정이 다녀왔습니다.

12.01 ~ 12.02 포스터 발표가 있었습니다.

동현이는 우수 포스터상을 받았습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2MCZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyMw==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481890362.jpg'),
('459','459','122','2016 ANS','2016.11.30 ~ 2016.12.04

일본 가고시마

ANS2016 학회에

교수님, 결, 다운, 동현, 창환, 윤정이 다녀왔습니다.

둘째날(12.02)에는 교수님께서

oral presentation를 하셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1OSZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyMg==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481889830.jpg'),
('458','458','121','2016 ANS','2016.11.30 ~ 2016.12.04

일본 가고시마

ANS2016 학회에

교수님, 결, 다운, 동현, 창환, 윤정이 다녀왔습니다.

둘째날(12.02)에는 결이의

oral presentation이 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1OCZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyMQ==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481889435.jpg'),
('457','457','120','2016 ANS','2016.11.30 ~ 2016.12.04

일본 가고시마

ANS2016 학회에

교수님, 결, 다운, 동현, 창환, 윤정이 다녀왔습니다.

12.01 ~ 12.02 포스터 발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1NyZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTEyMA==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481888130.jpg'),
('455','455','119','2016 ANS','2016.11.30 ~ 2016.12.05

일본 가고시마

ANS2016 학회에

교수님, 결, 다운, 동현, 창환, 윤정이 다녀왔습니다.

첫째날 사쿠라지마를 배경으로 사진을 찍었습니다~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1NSZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTExOQ==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481887266.jpg'),
('454','454','118','2016 하계분석분과회','2016.06.30 ~ 2016.07.01

부산에서 열린 하계분석분과회에 다녀왔습니다.

학회 후 해운대 바닷가에서 교수님과 ASL 멤버들이 즐거운 시간을 보냈습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1NCZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTExOA==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481867248.jpg'),
('451','451','117','2016 하계분석분과회','2016.06.30 ~ 2016.07.01

부산에서 열린 하계분석분과회에 다녀왔습니다.

ASL 멤버들 모두 포스터 발표를 했고,

장결 학생과, 퉁뚜이부 학생이 우수 포스터 상을 받았습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1MSZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTExNw==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481866616.jpg'),
('450','450','116','2016 스승의 날 행사','2016.05.20

스승의날 행사

등산 후 졸업하신 선배님들과 즐거운 시간을 가졌습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1MCZwYWdlY250PTEmbGV0dGVyX25vPTEyNyZvZmZzZXQ9OTYmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTExNg==||&boardIndex=2&sub=1&gubun=','127',9,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481866242.jpg'),
('449','449','115','2016 스승의 날 행사','2016.05.20

스승의 날 행사로

교수님과 ASL 연구실 멤버들이 아차산 등산을 다녀왔습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ0OSZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMTU=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21481866104.jpg'),
('396','396','114','Doctor Muya presented for KRF program','Doctor Muya presented for KRF program','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM5NiZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMTQ=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21462252975.jpg'),
('395','395','113','2016 Chemistry Department Symposium','2016 Chemistry Department Symposium','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM5NSZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMTM=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21462252626.jpg'),
('394','394','112','KCS 2016 - Analytical Chemistry Division Award for Excellent Research','Pham Khac Duy','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM5NCZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMTI=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21462252580.jpg'),
('393','393','111','2016 KCS','Vu Duy Tung','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM5MyZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMTE=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21462252508.jpg'),
('392','392','110','2016 KCS','Chang Kyong','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM5MiZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMTA=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21462252452.jpg'),
('350','350','109','2015 End Year Party','2015 End Year Party','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM1MCZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDk=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148633.jpg'),
('349','349','108','2015 KCS','2015 KCS','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0OSZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDg=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148439.jpg'),
('348','348','107','2015 KCS','2015 KCS','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0OCZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDc=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148760.jpg'),
('347','347','106','2015 KCS','2015 KCS','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0NyZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDY=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148375.jpg'),
('346','346','105','2015 KCS','2015 KCS','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0NiZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDU=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148345.jpg'),
('345','345','104','2015 SCIX','2015 SCIX','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0NSZwYWdlY250PTEmbGV0dGVyX25vPTExNSZvZmZzZXQ9MTA4JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDQ=||&boardIndex=2&sub=1&gubun=','115',10,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148300.jpg'),
('344','344','103','2015 PITTCON','2015 PITTCON','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0NCZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDM=||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21452148120.jpg'),
('314','314','102','2014 송년회','2014.12.26

2014년을 마무리하며 ASL 송년회를 했습니다~

졸업하신 선배님들도 오셔서 즐거운 시간을 보냈습니다','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMxNCZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDI=||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419903349.jpg'),
('313','313','101','2014 회식','Fai의 송별회 및 회식을 했습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMxMyZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDE=||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419902885.jpg'),
('312','312','100','2014년도 화학과 심포지엄','2014.9.1 - 9.2

양평 코바코 연수원

2014 화학과 심포지엄에 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMxMiZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0xMDA=||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419900024.jpg'),
('311','311','99','2014 여름 MT','2014. 8. 27 - 2014. 8. 28

경기도 가평

교수님, ASL 멤버들

Duy오빠 부모님, Tung동생, 그리고 이영복 선배님 연구실 학생들과

1박 2일 엠티를 다녀왔습니다~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMxMSZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05OQ==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419899796.jpg'),
('309','309','98','2014 여름 MT','2014. 8. 27 - 2014. 8. 28

경기도 가평

교수님, ASL 멤버들

Duy오빠 부모님, Tung동생, 그리고 이영복 선배님 연구실 학생들과

1박 2일 엠티를 다녀왔습니다~~

펜션 수영장에서 재밌게 놀았습니다^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMwOSZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05OA==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419856731.jpg'),
('304','304','97','2014 여름 MT','2014. 8. 27 - 2014. 8. 28

경기도 가평

교수님, ASL 멤버들

Duy오빠 부모님, Tung동생, 그리고 이영복 선배님 연구실 학생들과

1박 2일 엠티를 다녀왔습니다~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMwNCZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05Nw==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419855745.jpg'),
('302','302','96','2014 여름 MT','2014. 8. 27 - 2014. 8. 28

경기도 가평

교수님, ASL 멤버들

Duy오빠 부모님,Tung동생, 그리고 이영복 선배님 연구실 학생들과

1박 2일 엠티를 다녀왔습니다~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMwMiZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05Ng==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419855650.jpg'),
('301','301','95','2014 ANS','2014.6.17 - 2014.6.20

대구 인터불고 호텔

2014 Asia NIR 학회에 교수님, 진영, 진아, 결, 다운이 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMwMSZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05NQ==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419853372.jpg'),
('300','300','94','2014 ANS','2014.6.17 - 2014.6.20

대구 인터불고 호텔

2014 Asia NIR 학회에 교수님, 진영, 진아, 결, 다운이 참석하였습니다.

학회 내내 교수님께서는 매우 바쁜 일정을 가지셨습니다 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMwMCZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05NA==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419853158.jpg'),
('299','299','93','2014 ANS','2014.6.17 - 2014.6.20

대구 인터불고 호텔

2014 Asia NIR 학회에 교수님, 진영, 진아, 결, 다운이 참석하였습니다.

학회 내내 교수님께서는 매우 바쁜 일정을 가지셨습니다 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTI5OSZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05Mw==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419853092.jpg'),
('298','298','92','2014 ANS','2014.6.17 - 2014.6.20

대구 인터불고 호텔

2014 Asia NIR 학회에

교수님, 진영, 진아, 결, 다운이 참석하였습니다.

학회에 참석하신 모든 분들과 함께 찍은 기념사진 입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTI5OCZwYWdlY250PTImbGV0dGVyX25vPTEwMyZvZmZzZXQ9MTIwJnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT05Mg==||&boardIndex=2&sub=1&gubun=','103',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21419845651.jpg'),
('203','203','91','2014년 첫 회식 ~~~','2014년을 맞이하여

다시 컴백한 베트남 학생들과 함께

첫 회식이 있었습니다~

이번회식은 교수님께서 소개해 주신 곱창집이였는데

특이하게 깔깔이를 입고 곱창을 먹었습니다~~~~!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTIwMyZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTkx||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21392620189.jpg'),
('186','186','90','2013 ICAVS','2013.8.24 - 8.31

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.

8.29 포스터 발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE4NiZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTkw||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381807007.jpg'),
('185','185','89','2013 ICAVS7','2013.8.24 - 8.31

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE4NSZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTg5||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381807064.jpg'),
('179','179','88','2013 ICAVS7','2013.8.24 - 8.31

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.

학회를 마치고 강원대학교 정영미 교수님 연구실 분들과 함께

저녁식사를 하며 즐거운 시간을 보냈습니다.

맛있는 저녁을 사주셨습니다 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3OSZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTg4||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381803783.jpg'),
('178','178','87','2013 ICAVS7','2013.8.24 - 8.31

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.

#1. 학회 첫날 두이의 포스터 발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3OCZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTg3||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381803681.jpg'),
('176','176','86','2013 ICAVS7','2013.8.24 - 8.31

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.

#1. 오사카,도톤보리 게요리 전문점에서 식사를 마치고

#2. 음식점 점원분과 함께','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3NiZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTg2||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381802588.jpg'),
('175','175','85','2013 ICAVS7','2013.8.24 - 8.31

일본 오사카,고베

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.

#1. 학회 시작 전, 오사카에서 ASL 멤버들끼리 즐거운 시간을 가졌습니다.

#2. 오사카 게요리 전문점,가니도라쿠에서 맛있는 점심을 먹었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3NSZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTg1||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381802427.jpg'),
('174','174','84','2013 ICAVS7','2013.8.24 - 8.31

2013 ICAVS7 학회에 진영,샛별,두이,진아,결이 참석하였습니다.

#1. 학회가 열린 고베 포트아일랜드의 컨벤션 센터

#2. 학회장 내 포스터 세션 모습','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3NCZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTg0||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381802218.jpg'),
('173','173','83','2DCOS-7','2013.8.21 - 8.24

이화여자대학교

2DCOS-7 학회에 교수님과 함께 결,두이가 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3MyZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTgz||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381802021.jpg'),
('172','172','82','2DCOS-7','2013.8.21 - 8.24

이화여자대학교

2DCOS-7 학회에 교수님과 함께 결,두이가 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3MiZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTgy||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381801986.jpg'),
('171','171','81','2013 화학과 심포지엄','2013.9.5 - 9.6

만리포 한양여대 수련원

2013 화학과 심포지엄에 참석하였습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3MSZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTgx||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381801827.jpg'),
('170','170','80','2013 춘계 분석과학회 발표','2013.5.31

춘계 한국분석과학회에서

윤지혜 학생의 발표가 있었습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTE3MCZwYWdlY250PTImbGV0dGVyX25vPTkxJm9mZnNldD0xMzImc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTgw||&boardIndex=2&sub=1&gubun=','91',12,'http://asl.hanyang.ac.kr/upload/bbs/a_img21381801742.jpg'),
('110','110','79','태국 치앙마이 대학교에 다녀오셨습니다_2','교수님께서 2012년 11월

한양대학교 자연과학대학과 MOU를 맺은 태국 치앙마이 대학교에 다녀오셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTExMCZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTc5||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358162170.jpg'),
('109','109','78','태국 치앙마이 대학교에 다녀오셨습니다_1','교수님께서 2012년 11월

한양대학교 자연과학대학과 MOU를 맺은 태국 치앙마이 대학교에 다녀오셨습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwOSZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTc4||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358162136.jpg'),
('108','108','77','2012년도 화학과 심포지엄','화학과 심포지엄에 다녀왔습니다.

ASL 단체사진 올려요~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwOCZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTc3||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358162093.jpg'),
('107','107','76','2012 CHEMOMETRICS 학회에 다녀왔습니다_3','2012. 6 /23 ~6 /30

헝가리 부다페스트에서 열린 CHEMOMETRICS IN ANALYTICAL CHEMISTRY 학회에 다녀왔습니다 !

학회 포스터 앞에서 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwNyZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTc2||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358162028.jpg'),
('106','106','75','2012 CHEMOMETRICS 학회에 다녀왔습니다_2','2012. 6 /23 ~6 /30

헝가리 부다페스트에서 열린 CHEMOMETRICS IN ANALYTICAL CHEMISTRY 학회에 다녀왔습니다

일정 중 독일에 들려 이재경 선배님도 만나뵈었습니다 ^^

두번째 사진은 헝가리의 전경입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwNiZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTc1||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161954.jpg'),
('104','104','74','2012 CHEMOMETRICS 학회에 다녀왔습니다_1','2012. 6 /23 ~6 /30

헝가리 부다페스트에서 열린 CHEMOMETRICS IN ANALYTICAL CHEMISTRY 학회에 다녀왔습니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwNCZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTc0||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161896.jpg'),
('103','103','73','2012 ASIA NIR 학회에 다녀왔습니다_5','2012.5.14 ~ 5.18

태국에서 열린 2012 Asia NIR 학회에 교수님 그리고 지혜, 진아가 다녀왔습니다.

5/16 학회 첫째날,

저녁에 열린 banquet 에서 학회에 참여하신 여러 한국 교수님들과 함께 즐거운 시간을 가졌습니다^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwMyZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTcz||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161763.jpg'),
('102','102','72','2012 ASIA NIR 학회에 다녀왔습니다_4','2012.5.14 ~ 5.18

태국에서 열린 2012 Asia NIR 학회에 교수님 그리고 지혜, 진아가 다녀왔습니다.

학회 내내 교수님께서는 매우 바쁜 일정을 가지셨습니다 ^^

학회에 참석하신 모든 분들과 함께 찍은 기념사진 입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwMiZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTcy||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161613.jpg'),
('101','101','71','2012 ASIA NIR 학회에 다녀왔습니다_3','2012.5.14 ~ 5.18

태국에서 열린 2012 Asia NIR 학회에 교수님 그리고 지혜, 진아가 다녀왔습니다.

5/16 학회 첫째날은 지혜, 5/17 둘째날은 진아가 각각 oral presentation 이 있었습니다.^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwMSZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTcx||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161582.jpg'),
('100','100','70','2012 ASIA NIR 학회에 다녀왔습니다_2','2012.5.14 ~ 5.18

태국에서 열린 2012 Asia NIR 학회에 교수님 그리고 지혜, 진아가 다녀왔습니다.

5/17 학회 둘째날, 교수님께서 Invited lecture가 있으셨습니다 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTEwMCZwYWdlY250PTImbGV0dGVyX25vPTc5Jm9mZnNldD0xNDQmc2VhcmNoPSZzZWFyY2hzdHJpbmc9JnByZXNlbnRfbnVtPTcw||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161539.jpg'),
('99','99','69','2012 ASIA NIR 학회에 다녀왔습니다_1','2012.5.14 ~ 5.18

태국에서 열린 2012 Asia NIR 학회에 교수님 그리고 지혜, 진아가 다녀왔습니다.

5/17 학회 둘째날, 교수님께서 Invited lecture가 있으셨습니다 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk5JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Nzkmb2Zmc2V0PTE0NCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Njk=||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161482.jpg'),
('98','98','68','아이오와에 갔습니다_4','학교 관광이 끝나고 Morrison Park 에서 저녁을 먹었습니다.

교수님께서 직접! 스테이크를 구워주셔서

정말 맛있게 먹었습니다. >_<

강병기 박사님께서도 함께 해주셔서 즐거운 시간을 보냈습니다.^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk4JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Nzkmb2Zmc2V0PTE0NCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Njg=||&boardIndex=2&sub=1&gubun=','79',13,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161358.jpg'),
('97','97','67','아이오와에 갔습니다_3','교수님께서 연구년에 들리셨을때 홍수가 났었다던

문제의 Iowa river 입니다.

그리고 한규 오빠가 일하고 계신 Anold 교수님 연구실에 들렀던

인증샷 입니다!!^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk3JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Njc=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358161299.jpg'),
('96','96','66','아이오와에 갔습니다_2','U of Iowa 안에 있는 한국 식당에서 다같이 점심을 먹었습니다.

동양인들이 참 많이 오는 인기 장소 였습니다.

그리고 Anold 교수님과 한규오빠가 있는

Iowa Advanced Technology Laboratories 입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk2JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjY=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160523.jpg'),
('95','95','65','아이오와에 갔습니다_1','보스턴에서 한국으로 돌아오기 전, 아이오와에 잠시 들렀습니다.

정회일 교수님께서 다니신 U of Iowa에 가서 구경 했습니다.

정말 좋은 곳이더군요!!! >_<','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk1JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjU=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160476.jpg'),
('94','94','64','22회 라만 학회를 다녀왔습니다_3','포스터 발표 현장 입니다!!

열심히 설명하고 있었습니다.^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTk0JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjQ=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160436.jpg'),
('93','93','63','22회 라만 학회를 다녀왔습니다_2','포스터 발표 및 Boston 의 Downtown 사진 입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkzJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjM=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160394.jpg'),
('92','92','62','22회 라만 학회를 다녀왔습니다_1','Boston 에서 라만 학회가 지난 8월 8~13일 까지 있었습니다.

학회 장소 근처에 있어서 쉬는시간에 잠시 구경했던

Boston Common Park 에서 찍은 사진과

학회측에서 준비해준 Boston Red Sox 홈 구장인

Fenway Park 에서 찍은 사진입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkyJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjI=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160354.jpg'),
('91','91','61','미소와 교수님','석찬형과 민정누나의 딸 미소와 교수님','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkxJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjE=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160293.jpg'),
('90','90','60','Farewell party with Lawan','Farewell party with Lawan','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTkwJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NjA=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160243.jpg'),
('89','89','59','2009 피츠버그 컨퍼런스 사진들 2','2009 피츠버그 컨퍼런스 사진들 2','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg5JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTk=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160218.jpg'),
('88','88','58','2009 피츠버그 컨퍼런스 사진들 1','2009 피츠버그 컨퍼런스 사진들 1','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg4JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTg=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160201.jpg'),
('87','87','57','교수님 캐리커처','이번에 졸업하는 학부생들의 졸업선물입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg3JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTc=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160176.jpg'),
('86','86','56','NIR 학회','NIR 학회','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg2JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89Njcmb2Zmc2V0PTE1NiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTY=||&boardIndex=2&sub=1&gubun=','67',14,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160132.jpg'),
('85','85','55','NIR 학회','저녁파티에서...1','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg1JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTU=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160096.jpg'),
('84','84','54','NIR 학회 발표3','교수님 구두발표','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTg0JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTQ=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160058.jpg'),
('83','83','53','NIR 학회 발표2','포스터발표와 우수포스터상시상','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTgzJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTM=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358160022.jpg'),
('82','82','52','NIR 학회 발표1','NIR 학회 발표1','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTgyJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTI=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159969.jpg'),
('81','81','51','2008 상반기 대한화학회 2','일산 킨텍스에서 4월17,18에 있었던

2008 상반기 대한화학회 포스터 발표입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTgxJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTE=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159929.jpg'),
('80','80','50','2008 상반기 대한화학회','일산 킨텍스에서 4월17,18에 있었던

2008 상반기 대한화학회 포스터 발표입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTgwJnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NTA=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159862.jpg'),
('79','79','49','2008 피츠버그 컨퍼런스 사진들_4','2008 피츠버그 컨퍼런스 사진들_3','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc5JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDk=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159760.jpg'),
('78','78','48','2008 피츠버그 컨퍼런스 사진들_3','2008 피츠버그 컨퍼런스 사진들_3','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc4JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDg=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159689.jpg'),
('77','77','47','2008 피츠버그 컨퍼런스 사진들_2','2008 피츠버그 컨퍼런스 사진들_2','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc3JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDc=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159577.jpg'),
('76','76','46','2008 피츠버그 컨퍼런스 사진들_1','2008 피츠버그 컨퍼런스 사진들_','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc2JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDY=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159527.jpg'),
('75','75','45','ASL MEMBERS','어느 화창한 봄날에...','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc1JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDU=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159500.jpg'),
('74','74','44','미국생활 2','학교편은 다음에....','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTc0JnBhZ2VjbnQ9MiZsZXR0ZXJfbm89NTUmb2Zmc2V0PTE2OCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDQ=||&boardIndex=2&sub=1&gubun=','55',15,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159466.jpg'),
('73','73','43','미국생활','미국생활','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTczJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDM=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159385.jpg'),
('72','72','42','2007 FACSS CONFERENCE','포스터발표장^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcyJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDI=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159306.jpg'),
('71','71','41','2007 FACSS CONFERENCE','학회가 열린 memphis cook convention center 앞 정경^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTcxJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDE=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159228.jpg'),
('69','69','40','2007 Asianalysis 제주도 라마다 호텔 2','2007 Asianalysis 제주도 라마다 호텔 2','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY5JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09NDA=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159097.jpg'),
('68','68','39','2007 Asianalysis 제주도 라마다 호텔입니다. ^^','2007 Asianalysis 제주도 라마다 호텔입니다. ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY4JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Mzk=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159073.jpg'),
('67','67','38','2007분석과학회 창원대학교','창원대학교에서 분석과학회 사진입니다. ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY3JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Mzg=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358159037.jpg'),
('66','66','37','2007년 상반기 대한화학회 코엑스 ^^','2007년 상반기 대한화학회 코엑스 ^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY2JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Mzc=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158999.jpg'),
('65','65','36','2007년 pittcon 국제학회 3','2007년 pittcon 국제학회 3','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY1JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzY=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158895.jpg'),
('64','64','35','2007년 pittcon 국제학회 2','2007년 pittcon 국제학회 2','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTY0JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzU=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158770.jpg'),
('63','63','34','2007년 pittcon 국제학회 1','2007년 pittcon 국제학회 1','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYzJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzQ=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158735.jpg'),
('62','62','33','2006년 춘계 대한화학회','초대 가수였던 서수남씨, 우리교수님, 울산대 이영일교수님','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYyJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzM=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158698.jpg'),
('61','61','32','2006년 춘계 대한화학회','현재 ASL의 대학원생과 교수님입니다.

장소는 일산의 KINTEX','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYxJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NDMmb2Zmc2V0PTE4MCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzI=||&boardIndex=2&sub=1&gubun=','43',null,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158635.jpg'),
('60','60','31','NIR 학회','관서대 오자키 교수님과 우리 교수님','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTYwJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzE=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158598.jpg'),
('59','59','30','겨울 스키 MT','ASL의 2005 ~ 2006년 겨울 스키 여행

강원도 휘닉스 파크입니다.','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU5JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MzA=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158562.jpg'),
('58','58','29','전기분석분과회_속초','속초 가는길...

건조한 날씨에 불에 타버린...사찰에도 잠시..','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU4JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Mjk=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158524.jpg'),
('57','57','28','2005.5.대한화학회','포스터상 받았지요~^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU3JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Mjg=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158453.jpg'),
('56','56','27','강촌 MT','강촌 MT','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU2JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09Mjc=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158378.jpg'),
('55','55','26','속초 전기분석분과회의','속초 전기분석분과회의','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU1JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjY=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158329.jpg'),
('54','54','25','강촌 5월 MT','강촌 ''호수가 있는 풍경''에서...','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTU0JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjU=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158293.jpg'),
('53','53','24','상하이 학회3','교수님의 2번째 발표입니다...

원래 하나만 하시기로 했는데...

일명...대타^^;;;...그러고보니 교수님 발표사진만 찍었네요...

굉장히 많으신 분들의 발표가 있었으사 사진 분실관계로^^;;;;;

호홋....

이날은 같이 가셨던 최창현 교수님과 김효진교수님의 발표도 있었습니다,,,','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTUzJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjQ=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158199.jpg'),
('52','52','23','상하이 학회2','첫번째 사진은 교수님과 우영아 박사님, 최창현 박사님께서 우영아 박사님 포스터 앞에서 한컷!~~~남매 같나요?^^;;;;

두번째 사진은 교수님의 첫번째 발표인데요...플레쉬를 못터뜨리는 바람에...이렇게..--+

교수님 발표 제일루 잘하셨어요...홍홍홍','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTUyJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjM=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358158128.jpg'),
('51','51','22','상하이 학회1','CCBA 2004 상하이 학회 사진입니다

학회가 있었던 퉁지 대학 정문 사진과 독일관 사진이입니다

생각보다 넓고 깨끗한 학교더군요....그리고 학과마다 건물이 따로 있어서

부럽더군요...화학관..ㅠ.ㅠ','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTUxJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjI=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157925.jpg'),
('50','50','21','ㅋㅋㅋ 한규오빠...^^','ㅋㅋㅋ 한규오빠...^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTUwJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjE=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157875.jpg'),
('49','49','20','심포지엄 양평','ㅋㅋㅋ 랩사람들이 찍힌 사진인데...

도학오래비의 작품입니다...

이뿌게 찍어 달래니깐...ㅋㅋㅋ','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ5JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MzEmb2Zmc2V0PTE5MiZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MjA=||&boardIndex=2&sub=1&gubun=','31',17,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157850.jpg'),
('48','48','19','곤도라 안에서...','곤도라 안에서 즐거워서 찍어봤습니다....^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ4JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTk=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157816.jpg'),
('47','47','18','ㅋㅋㅋ 오래비들...','괜히 폼잡고 한방~~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ3JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTg=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157770.jpg'),
('46','46','17','역시..정상...','사람들이 다 찍길래...비석(?)에 둘러모여 한방~~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ2JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTc=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157726.jpg'),
('45','45','16','향적봉','ㅋㅋㅋ 괜히 높이 올라온것 처럼 보이려고...표지판에서 찍었습니다만은...

ㅋㅋㅋ 곤도라타고 올라갔다는...^^;;;','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ1JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTY=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157692.jpg'),
('44','44','15','무주 덕유산 정상에서','덕유산 정상에 갔더랬습니다...

뿌연건 안개가 아니라 구름입니다...

구름속에서 산을 올랐습니다...ㅋㅋㅋ 신선이 된 느낌 이었죠...^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQ0JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTU=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157655.jpg'),
('43','43','14','무주에서...','무주에서...','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQzJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTQ=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157610.jpg'),
('42','42','13','무주에서...','무주에서...','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQyJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTM=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157544.jpg'),
('41','41','12','펠렛 370개 달성!!!','미션: 스키장에 가기전까지 370개!!

모두의 도움으로 철원오래비와 쑤아의 미션이 무사히 수행되었다.

와우~~~ 눈물겨운 끝이라...펠렛의 사체(?)를 보며 가슴 찡한 감동을...ㅠ.ㅠ

처음으로 완벽한 놈을 하나 만들어서 기념사진..찰칵..!!!

찍새의 숙련되지 못한 실력으로 초점 흔들림..--+

어쨋거나...철원오래비도 저런 표정을 지을수 있다는 걸 알았다...','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQxJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTI=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157510.jpg'),
('40','40','11','2003 송년회2','울방 커플 승재오래비와 민식 오래비...둘의 우정이 영원하길...쭈욱~~~^^*

민식오래비..무리했나요?^^;;; 눈 풀려써...^^;;;

밑은 이쁜 민정이와 수연이...아휴...귀여워.~~~^^*

수연이 표정이 엽기적이지만...민정이랑 찍은게 이거박에 없어서..용서바람..^^;;

모두모두...사랑함다..^^

앗~~~울 교수님 사진이 엄따...^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTQwJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTE=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157471.jpg'),
('39','39','10','2003년 송년회1','2003년 송년회~~~~

한진욱 교수님방과 조인트 송년회...^^

울방 멤버 전원이 참석해 더욱 즐거운 자리였다...

귀여운 경희언니와 한진욱 교수님 그리고 뒤에 잠깐 지나가다 찍힌 한규오래비^^

밑에 사진은 울 방의 귀여운 찬오래비와 진태오래비...^^

모두모두 즐거운 날이었길....^^','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM5JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09MTA=||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157408.jpg'),
('38','38','9','도요다 상~~~','일본의 도요다 교수님...

너무너무 순수하고 착하신 우리 도요다 교수님...

아쉽게도..Mrs. Toyda를 못찍었다...(우리의 일본 부모님...^^:;)

Toyoda상은 전에 혼다에서 일해서 차는 혼다를 타신다...^^

아 이번에 구입하신 차는 도요다 맞다..^^;;;;

맞나?^^;;;;','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM4JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09OQ==||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157357.jpg'),
('37','37','8','인체영상 연구회 심포지엄','심포지엄에 참석했던 학생들...^^;;;

울방 오래비들...그리고 울방 마스코트 이뿐 수연이

수연 옆에 있는 똑똑해 보이는 언니가 동덕여대 강나루 언니..

이름도 이뿌다..^^

다른 대학원생들과 교수님들의 옆 자리에서 회식중...

맛난 샤브샤브와 칼국수...캬~~~','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM3JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89MTkmb2Zmc2V0PTIwNCZzZWFyY2g9JnNlYXJjaHN0cmluZz0mcHJlc2VudF9udW09OA==||&boardIndex=2&sub=1&gubun=','19',18,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157303.jpg'),
('36','36','7','인체영상 연구회 심포지엄','이날 발표는 포항공대 제정호 교수님과 민병호 박사님의 발표로 진행되었다.

차마 플레쉬를 터트리지 못해..어두워 알수 없다..--;;;;

제정호교수님은 포항공대의 제 3세대 가속기의 보유를 장점으로 현재 의료에

사용되는 방사선 연구에 대해 주로 연구를 하고 계신듯...4세대 가속기만

만들어진다면 우리가 꿈에도 그리던 원자를 눈으로 볼수 있는 세상이 올 수

있다는 기대를 해 본다...','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM2JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT03||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157155.jpg'),
('35','35','6','민식오래비의 변화^O^','민식오래비가 매일 아침 8시에 학교에 온다...놀라운 변화다...^^

역시 외국을 다녀온 효과가 나타나는 것인지.....

영어공부에 일어공부에...이젠 전공공부 전념이다....

아침부터 공부를 하는 모습이 포착되었다...이런 모습이 계속되었으면 하는 바램이 있

민식 오래비 화이팅!!!!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM1JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT02||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358157044.jpg'),
('34','34','5','오사카 성','19일은 학교 건물의 전기와 수도 점검을 하는 날이라 학교를 가지 못(!)했다...

교수님은 게스트 하우스서 일을 하시고(!!!) 학생은 놀러 나갔다(^^;;;;;)

오사카 성이다........16세기 일본을 통일하고 우리나라까지 침범한 도요토미가

만든 성이다....당시부터 오사카가 일본에서 떠오르는 도시가 된 때문인지...오사카 사람

들은 이 "오사카조"를 상당히 자랑스럽게 여긴다....상당히 수려한 외관을 자랑한다...

주변은 전체를 공원처럼 꾸며 놓았다....올라가기전 아래에서...한컷!!!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTM0JnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT01||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358156972.jpg'),
('33','33','4','식당과 휴식 공간(?)','생협(학생 협동 조합?)이라고 불리는 건물이다......1층이 식당...2층이 매점이다....

매점에는 별게 다 있다...오토바이도 있다..^^

식당음식은 무난한 편이다...외부의 도시락에 비하면 좀 비싼 감이 없지 않다...

그러나 우리에겐 선택의 여지가 없다^^;;;;','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMzJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT00||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358156906.jpg'),
('32','32','3','도서관','도서관 외부모습이다...오늘까지 휴일인 관계로 들어갈 수 없다...^^

직원이 매우 친절하다...도서관 카드까지 발급받았지만...복사와 논문 때문에 두어번

이용한..^^;;;;............일본어로 된책이 매우 많다...영어의 컴플렉스인 것두 있을지...

모르지만...다양하게 필요한 책을 국내에서 직접 만드는 일본인듯.....일단 관련서적은

무지 많다...일본어로 되어있다는 단점을 빼면.......논문도 참 잘 모아 놓았더군...

찾기두 싶구....','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMyJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0z||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358156849.jpg'),
('31','31','2','이공학부 건물!!!','우리가 공부하고 있는 이공학부 본관(?)이다...

내부도 상당히 깨끗하다......부러워..ㅠ.ㅠ

이곳 산다 캠퍼스에는 자연과학부와 경제학부만 이전해왔다고 한다....','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMxJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0y||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358156709.jpg'),
('30','30','1','관서 학원 대학 입구','관서 학원 대학....三田 캠퍼스

학교가 전체적으로 너무 너무 예쁘다...きれいね~~~

정문쪽에서 한컷!!!','','','http://asl.hanyang.ac.kr/05.php?type=view&data=aWR4PTMwJnBhZ2VjbnQ9MyZsZXR0ZXJfbm89NyZvZmZzZXQ9MjE2JnNlYXJjaD0mc2VhcmNoc3RyaW5nPSZwcmVzZW50X251bT0x||&boardIndex=2&sub=1&gubun=','7',19,'http://asl.hanyang.ac.kr/upload/bbs/a_img21358156644.jpg');


with matched as (
  select
    g.id as gallery_id,
    l.*
  from public.gallery_posts g
  left join tmp_gallery_legacy l1 on l1.source_present_num <> '' and l1.source_present_num = g.source_present_num
  left join tmp_gallery_legacy l2 on l1.id is null and l2.source_idx <> '' and l2.source_idx = g.source_idx
  left join tmp_gallery_legacy l3 on l1.id is null and l2.id is null and l3.id = g.id
  cross join lateral (
    select coalesce(l1.id, l2.id, l3.id) as id,
           coalesce(l1.source_idx, l2.source_idx, l3.source_idx) as source_idx,
           coalesce(l1.source_present_num, l2.source_present_num, l3.source_present_num) as source_present_num,
           coalesce(l1.title, l2.title, l3.title) as title,
           coalesce(l1.content, l2.content, l3.content) as content,
           coalesce(l1.author, l2.author, l3.author) as author,
           coalesce(l1.date_text, l2.date_text, l3.date_text) as date_text,
           coalesce(l1.source_url, l2.source_url, l3.source_url) as source_url,
           coalesce(l1.source_letter_no, l2.source_letter_no, l3.source_letter_no) as source_letter_no,
           coalesce(l1.list_page_num, l2.list_page_num, l3.list_page_num) as list_page_num,
           coalesce(l1.thumbnail_url, l2.thumbnail_url, l3.thumbnail_url) as thumbnail_url
  ) l
  where l.id is not null
), updated as (
  update public.gallery_posts g
  set
    title = case
      when (trim(coalesce(g.title,'')) = '' or lower(trim(g.title)) in ('content','컨텐츠 바로가기','콘텐츠 바로가기'))
           and trim(coalesce(m.title,'')) <> ''
      then m.title else g.title end,
    content = case when trim(coalesce(g.content,'')) = '' and trim(coalesce(m.content,'')) <> '' then m.content else g.content end,
    author = case when trim(coalesce(g.author,'')) = '' and trim(coalesce(m.author,'')) <> '' then m.author else g.author end,
    date_text = case when trim(coalesce(g.date_text,'')) = '' and trim(coalesce(m.date_text,'')) <> '' then m.date_text else g.date_text end,
    source_url = case when trim(coalesce(g.source_url,'')) = '' and trim(coalesce(m.source_url,'')) <> '' then m.source_url else g.source_url end,
    source_idx = case when trim(coalesce(g.source_idx,'')) = '' and trim(coalesce(m.source_idx,'')) <> '' then m.source_idx else g.source_idx end,
    source_letter_no = case when trim(coalesce(g.source_letter_no,'')) = '' and trim(coalesce(m.source_letter_no,'')) <> '' then m.source_letter_no else g.source_letter_no end,
    source_present_num = case when trim(coalesce(g.source_present_num,'')) = '' and trim(coalesce(m.source_present_num,'')) <> '' then m.source_present_num else g.source_present_num end,
    list_page_num = case when g.list_page_num is null and m.list_page_num is not null then m.list_page_num else g.list_page_num end,
    thumbnail_url = case when trim(coalesce(g.thumbnail_url,'')) = '' and trim(coalesce(m.thumbnail_url,'')) <> '' then m.thumbnail_url else g.thumbnail_url end
  from matched m
  where g.id = m.gallery_id
  returning g.id
)
select count(*) as updated_rows from updated;
