<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%--
      [추가 1] 기본적인 메타 태그
      - charset: 문자 인코딩 (JSP의 contentType과 일치)
      - viewport: 모바일 기기에서 화면 크기를 올바르게 인식하도록 함 (필수!)
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%= request.getAttribute("title")%></title>

    <%--
      [추가 2] 파비콘 (Favicon)
      - 따로 이미지 파일 없이 이모지(🤖)로 파비콘을 만듭니다.
    --%>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🤖</text></svg>">

    <%--
      [추가 3] 검색엔진용 기본 설명
    --%>
    <meta name="description" content="간단한 AI 챗봇에게 무엇이든 물어보세요.">

    <%--
      [추가 4] OG (Open Graph) 태그 - 카톡, 페이스북 등 공유용
    --%>
    <meta property="og:type" content="website">
    <meta property="og:title" content="🤖 AI 챗봇">
    <meta property="og:description" content="AI에게 무엇이든 물어보세요!">
    <%--
      - 미리보기 이미지입니다. 1200x630 크기를 권장합니다.
      - placehold.co를 이용해 버튼 색상(#face5e)과 어울리는 임시 이미지를 만들었습니다.
    --%>
    <meta property="og:image" content="https://placehold.co/1200x630/FACE5E/333333?text=🤖%0AAI 챗봇&font=noto-sans-kr">
    <%--
      - <%= request.getRequestURL() %>를 사용해 현재 페이지의 전체 URL을 동적으로 넣어줍니다.
    --%>
    <meta property="og:url" content="<%= request.getRequestURL() %>">

    <%--
      [추가 5] 트위터 카드 태그 - X (트위터) 공유용
    --%>
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="🤖 AI 챗봇">
    <meta name="twitter:description" content="AI에게 무엇이든 물어보세요!">
    <meta name="twitter:image" content="https://placehold.co/1200x630/FACE5E/333333?text=🤖%0AAI 챗봇&font=noto-sans-kr">


    <%-- Google Fonts: 깔끔한 'Noto Sans KR' 폰트 적용 --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        /* 1. 기본 및 레이아웃 */
        body {
            /* - var(--...) : CSS 변수 (재사용을 위해)
              - system-ui : 운영체제 기본 폰트
              - 'Noto Sans KR' : 위에서 import한 구글 폰트
            */
            font-family: 'Noto Sans KR', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f0f2f5; /* 약간 따뜻한 회색 배경 */
            margin: 0;
            padding: 20px;

            /* Flexbox를 이용한 수직/수평 중앙 정렬 */
            display: flex;
            justify-content: center; /* 수평 중앙 */
            align-items: center;   /* 수직 중앙 */
            min-height: 100vh;     /* 최소 높이를 화면 전체 높이로 */
            box-sizing: border-box; /* padding이 크기에 포함되도록 */
        }

        /* 2. 메인 컨테이너 (카드 디자인) */
        .chat-container {
            width: 100%;
            max-width: 600px; /* 최대 너비 고정 */
            background: #ffffff;
            border-radius: 12px; /* 모서리를 더 둥글게 */
            /* 부드L러운 그림자 효과 */
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            padding: 32px;
            box-sizing: border-box;
        }

        /* 3. 제목 */
        h2 {
            text-align: center;
            color: #333;
            margin-top: 0;
            margin-bottom: 24px;
            font-weight: 700; /* 폰트 굵게 */
        }

        /* 4. 폼 (입력창 + 버튼) */
        form {
            display: flex; /* 자식 요소(input, button)를 가로로 배치 */
            gap: 8px; /* ⭐️ 추가: 자식 요소(input, button) 사이에 8px 간격 */
        }

        /* 5. 텍스트 입력창 */
        input[name="text"] {
            flex-grow: 1; /* 남은 공간을 모두 차지 */
            border: 2px solid #dde1e5;
            background: #fdfdfd;
            padding: 14px 16px;
            font-size: 16px;
            /* 왼쪽 모서리만 둥글게 */
            border-radius: 8px;

            /* 부드L러운 전환 효과 */
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        /* 입력창 포커스(클릭) 시 */
        input[name="text"]:focus {
            border-color: #4a90e2; /* 파란색 테두리 */
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2); /* 은은한 바깥 그림자 */
        }

        /* 6. 질문하기 버튼 */
        button {
            padding: 14px 20px;
            font-size: 16px;
            font-weight: 500;
            color: #ffffff;
            background-color: #face5e;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #fdad33;
        }

        /* 7. AI 답변 영역 */
        .answer-box {
            background-color: #f7f9fc;
            border: 1px solid #eef2f7;
            border-radius: 8px;
            padding: 14px 16px;
            margin-bottom: 24px;

            font-size: 16px;
            color: #444;
            line-height: 1.7;
            word-break: keep-all;

            .ai-answer {
                /* AI 응답 내부의 줄바꿈은 유지하도록 pre-wrap 적용 */
                white-space: pre-wrap;
                /* span은 기본적으로 inline 요소이므로,
                   줄바꿈 등을 올바르게 처리하기 위해 block 요소로 변경 */
                display: block;
            }
        }
    </style>
</head>

<body>
<div class="chat-container">
    <h2>🤖 AI 챗봇</h2>

    <div class="answer-box">
        <span class="emoji">🤖 삐-릭</span><br>
        <span class="ai-answer"><%= request.getAttribute("answer") %></span>
    </div>

    <form method="post">
        <input name="text" placeholder="질문을 입력하세요">
        <button>질문하기</button>
    </form>
</div>
</body>
</html>