package org.example.aiservlet.controller;

import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.aiservlet.service.AIService;

import java.io.IOException;

@WebServlet("/")
public class MainServlet extends HttpServlet {
    private AIService ai = null;

    @Override
    public void init() throws ServletException {
        ai = new AIService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("title", "AI가 질문을 답해줍니다!");
        // doGet (첫 로드) 시에는 "삐-릭" 뒤에 아무것도 표시되지 않도록 빈 문자열을 전달합니다.
        req.setAttribute("answer", ""); // " " 대신 ""
        req.getRequestDispatcher("/WEB-INF/chat.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String textParam = req.getParameter("text");

        // 1. 프롬프트 강화 (필수)
        // JSP가 "🤖 삐-릭"을 이미 표시하므로, AI가 "뼈-킥" 같은 자체 제목을
        // 절대 만들지 않도록 지시하는 것이 더 중요해졌습니다.
        String prompt = "%s. 응답에 제목, 서론, 이모지, '뼈-킥' 같은 단어 등 어떠한 꾸미는 텍스트도 절대 포함하지 마. 요청한 내용이나 목록만 바로 시작해.".formatted(textParam);
        String answer = ai.chatByGroq(prompt);

        // 2. 응답 문자열 가공 (핵심 로직 변경)
        // AI가 지시를 무시하고 "제목\n\n내용..." 형식으로 응답할 경우를 대비합니다.
        String separator = "\n\n";
        int contentStartIndex = answer.indexOf(separator);

        String finalAnswer;

        if (contentStartIndex != -1) {
            finalAnswer = answer.substring(contentStartIndex + separator.length());
        } else {
            finalAnswer = answer;
        }
        finalAnswer = finalAnswer.strip();

        req.setAttribute("title", "'%s'에 대한 AI의 답".formatted(textParam));

        req.setAttribute("answer", finalAnswer);
        req.getRequestDispatcher("/WEB-INF/chat.jsp").forward(req, resp);
    }
}