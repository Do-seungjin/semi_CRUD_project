package org.kosa.sj.post.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.kosa.sj.post.vo.BoardType;
import org.kosa.sj.post.vo.Post;

@Mapper
public interface PostDAO {
  public List<Post> list(Map<String, Object> map);
  public int getTotalCount(Map<String, Object> map);
  public List<BoardType> getBoardType();
  public int postRegist(Post post);
  public Post getPost(String postno);
  public int postUpdate(Post post);
  public int postDelete(String postNo);
  public void addViewCnt(String postNo);
}
