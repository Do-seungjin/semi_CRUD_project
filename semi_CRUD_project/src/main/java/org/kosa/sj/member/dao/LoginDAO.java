package org.kosa.sj.member.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.kosa.sj.member.vo.Member;

@Mapper
public interface LoginDAO {
  public int register(Member member);
  public Member getMember(String userid);
  public Member getMemberByNo(String userno);
  public void setLoginTime(String userid);
  public int update(Member member);
  public void history(Member member);
  public int delete(String userid);
  public List<Member> list(Map<String, Object> map);
  public int getTotalCount(Map<String, Object> map);
  public void addFailCnt(String userid);
  public int getFailCnt(String userid);
  public void changeLoginStatus(String userid);
  public void resetFailCnt(String userid);
  public int resetStatus(String userid);
  public int grantManager(String userid);
  public int revokeManager(String userid);
}
