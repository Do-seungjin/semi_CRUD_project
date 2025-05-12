package org.kosa.sj;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import org.kosa.sj.page.PageResponseVO;
import org.kosa.sj.post.service.PostService;
import org.kosa.sj.post.vo.BoardType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import lombok.extern.slf4j.Slf4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
public class HomeController {
  
  @Autowired
  private PostService postService;
  
  private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

  /**
   * Simply selects the home view to render by returning its name.
   */
  @RequestMapping(value = "/")
  public String home(Locale locale, Model model) {
    logger.info("Welcome home! The client locale is {}.", locale);

    Date date = new Date();
    DateFormat dateFormat =
        DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

    String formattedDate = dateFormat.format(date);
    for (int i = 0; i < 3; i++) {
      String boardNo = String.valueOf(i + 1); // 게시판 번호가 "1", "2", "3"이라고 가정
      PageResponseVO pageResponse = postService.list(1, 5, "", boardNo);
      model.addAttribute("pageResponse" + boardNo, pageResponse);
    }
    
    List<BoardType> boardType = postService.getBoardType();
    model.addAttribute("serverTime", formattedDate);
    model.addAttribute("boardType",boardType);
    return "home";
  }

}
