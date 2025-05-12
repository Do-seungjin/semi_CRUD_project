package org.kosa.sj.member.service;

import java.util.HashMap;
import java.util.Map;
import org.kosa.sj.member.dao.LoginDAO;
import org.kosa.sj.member.vo.Member;
import org.kosa.sj.page.PageResponseVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

  @Autowired
  private LoginDAO loginDAO;

  public PageResponseVO list(int pageNO, int size, String searchValue) {
    Map<String, Object> map = new HashMap<String, Object>();

    map.put("start", (pageNO - 1) * size + 1);
    map.put("list","member");
    map.put("end", pageNO * size);
    map.put("searchValue", searchValue);
    
    return new PageResponseVO(pageNO
        , loginDAO.list(map)
        , loginDAO.getTotalCount(map)
        ,size);
  }
  
  public int register(Member member) {
    int result = loginDAO.register(member);
    return result;
  }

  public Member getMember(String userid) {
    return loginDAO.getMember(userid);
  }

  public Map<String, Object> login(String userid, String passwd) {
    Map<String, Object> map = new HashMap<String, Object>();
    Member member = loginDAO.getMember(userid);
    int failCnt = loginDAO.getFailCnt(userid);
        
    if (member == null) {      
      map.put("res_code", "400");
      map.put("res_msg", "존재하는 회원정보가 없습니다.");
      return map;
    }
    
    if("Y".equals(member.getExitStatus())) {
      map.put("res_code", "400");
      map.put("res_msg", "존재하는 회원정보가 없습니다.");
      return map;
    }
    
    if("Y".equals(member.getAccountStatus())) {
      map.put("res_code", "400");
      map.put("res_msg", "로그인 잠금된 회원입니다. 관리자에게 문의하세요.");
      return map;
    }
    
    boolean result = member.getUserPwd().equals(passwd);
    if (result == false) {
      loginDAO.addFailCnt(userid);
      if(loginDAO.getFailCnt(userid) == 5) {
        loginDAO.changeLoginStatus(userid);
      }
      map.put("res_code", "400");
      map.put("res_msg", "비밀번호가 일치하지 않습니다.");
      return map;
    }
    loginDAO.resetFailCnt(userid);
    loginDAO.setLoginTime(userid);
    map.put("res_code", "200");
    return map;
  }

  public int update(Member member) {
    int result = 0;
    Member memberDB = loginDAO.getMember(member.getUserId());
    if (memberDB == null) {
      return result;
    }
    result = loginDAO.update(member);
    loginDAO.history(memberDB);
    if (result == 0) {
      return result;
    } else {
      result = 1;
      return result;
    }
  }
  
  public int delete(String userid) {
    int result = 0;
    Member memberDB = loginDAO.getMember(userid);
    if (memberDB == null) {
      return result;
    }
    return loginDAO.delete(userid);

  }

  public int resetStatus(String userid) {
    int result = 0;
    Member memberDB = loginDAO.getMember(userid);
    if (memberDB == null) {
      return result;
    }
    return loginDAO.resetStatus(userid);

  }

  public int grantManager(String userid) {
    int result = 0;
    Member memberDB = loginDAO.getMember(userid);
    if (memberDB == null) {
      return result;
    }
    return loginDAO.grantManager(userid);
  }
  
  public int revokeManager(String userid) {
    int result = 0;
    Member memberDB = loginDAO.getMember(userid);
    if (memberDB == null) {
      return result;
    }
    return loginDAO.revokeManager(userid);
  }
  



}
