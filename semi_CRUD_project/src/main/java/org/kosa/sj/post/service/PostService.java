package org.kosa.sj.post.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.kosa.sj.member.dao.LoginDAO;
import org.kosa.sj.member.vo.Member;
import org.kosa.sj.page.PageResponseVO;
import org.kosa.sj.post.dao.PostDAO;
import org.kosa.sj.post.vo.BoardType;
import org.kosa.sj.post.vo.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PostService {

  @Autowired
  private PostDAO postDAO;
  @Autowired
  private LoginDAO loginDAO;

  public PageResponseVO list(int pageNO, int size, String searchValue, String boardNo) {
    Map<String, Object> map = new HashMap<String, Object>();

    map.put("start", (pageNO - 1) * size + 1);
    map.put("list", "member");
    map.put("end", pageNO * size);
    map.put("searchValue", searchValue);
    map.put("boardNo", boardNo);
    return new PageResponseVO(pageNO, postDAO.list(map), postDAO.getTotalCount(map), size);
  }
  
  
  public List<BoardType> getBoardType() {
    List<BoardType> result = postDAO.getBoardType();
    return result;
  }

  public int postRegist(Post post) {
    int result = postDAO.postRegist(post);
    return result;
  }

  public Post getPost(String postno) {
    return postDAO.getPost(postno);
  }

  public int updatePost(Post post) {
    int result = postDAO.postUpdate(post);
    return result;
  }

  public int delete(String postNo) {
    int result = postDAO.postDelete(postNo);
    return result;
  }

  public void addViewCnt(String postno) {
    postDAO.addViewCnt(postno);
  }

  public Map<String, Object> userDelete(String postno, String userpwd) {
    Map<String, Object> map = new HashMap<String, Object>();
    Post post = postDAO.getPost(postno);
    Member member = loginDAO.getMemberByNo(post.getUserNo());
    if (member == null) {
      map.put("res_code", "400");
      map.put("res_msg", "존재하지 않는 사용자입니다.");
      return map;
    }
    if (member.getUserPwd().equals(userpwd)) {
      int result = postDAO.postDelete(postno);
      if (result == 1) {
        map.put("res_code", "200");
        map.put("res_msg", "게시물 삭제를 성공하였습니다.");
      } else {
        map.put("res_code", "400");
        map.put("res_msg", "게시물 삭제 중 오류가 발생하였습니다.");
      }
    } else {
      map.put("res_code", "400");
      map.put("res_msg", "비밀번호가 일치하지 않습니다.");
    }
    return map;
  }

}
