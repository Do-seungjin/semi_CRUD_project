package org.kosa.sj.member.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.kosa.sj.member.service.LoginService;
import org.kosa.sj.member.vo.Member;
import org.kosa.sj.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class LoginController {

  @Autowired
  LoginService loginService;

  // 로그인 화면 이동
  @RequestMapping("/loginForm")
  public String loginForm() {
    return "member/loginForm";
  }

  // 회원 가입 화면 이동
  @RequestMapping("/registerForm")
  public String registerForm() {
    return "member/registForm";
  }

  // 사용자 목록 화면 이동
  @RequestMapping("/userList")
  public String uesrList(Model model, String pageNo, String size, String searchValue) {
    model.addAttribute("pageResponse",
        loginService.list(Util.parseInt(pageNo, 1), Util.parseInt(size, 10), searchValue));
    return "member/userList";
  }

  // 회원가입
  @PostMapping("register")
  @ResponseBody
  public Map<String, Object> register(@RequestBody Member member) throws Exception {
    Map<String, Object> map = new HashMap<String, Object>();
    if (member == null) {
      map.put("res_code", "400");
      map.put("res_msg", "입력간에 오류가 발생하였습니다.");
    }
    int result = loginService.register(member);
    if (result == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "회원등록에 실패하였습니다.");
    } else {
      map.put("res_code", "200");
      map.put("res_msg", "성공적으로 회원등록을 완료하였습니다.");
    }
    return map;
  }

  // 아이디 중복 검사
  @PostMapping("isExistUserId")
  @ResponseBody
  public Map<String, Object> isExistUserId(@RequestBody Member member) {
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("existUserId", null != loginService.getMember(member.getUserId()));
    return map;
  }

  // 로그인
  @PostMapping("/login")
  @ResponseBody
  public Map<String, Object> login(HttpSession session, @RequestBody Member member) {
    Map<String, Object> map = new HashMap<String, Object>();
    if (member.getUserId() == null || member.getUserId().length() == 0
        || member.getUserPwd() == null || member.getUserPwd().length() == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "아이디 또는 비밀번호를 입력해주세요");
    } else {
      map = loginService.login(member.getUserId(), member.getUserPwd());
      if ("200".equals(map.get("res_code"))) {
        Member loginMember = loginService.getMember(member.getUserId());
        session.setAttribute("member", loginMember);
      }
    }
    return map;
  }

  // 로그아웃
  @RequestMapping("logout")
  public String logout(HttpSession session) {

    session.invalidate();

    return "redirect:/";
  }

  // 상세보기
  @RequestMapping("detailView")
  public String detailView(@RequestParam("userid") String userid, Model model) {
    Member memberInfo = loginService.getMember(userid);
    if (memberInfo == null) {
      return "redirect:/";
    }
    model.addAttribute("memberInfo", memberInfo);
    return "member/detailView";
  }

  // 수정 화면으로 이동
  @RequestMapping("updateForm")
  public String updateForm(Model model, String userid) {
    Member memberInfo = loginService.getMember(userid);
    if (memberInfo == null) {
      return "redirect:/";
    }
    model.addAttribute("memberInfo", memberInfo);
    return "member/updateForm";
  }

  // 수정 & 수정 이력 남기기
  @PostMapping("update")
  @ResponseBody
  public Map<String, Object> update(HttpSession session, @RequestBody Member member)
      throws Exception {
    Map<String, Object> map = new HashMap<String, Object>();
    int result = loginService.update(member);
    if (result == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "회원 정보 수정 중 오류가 발생하였습니다.");
    } else {
      map.put("res_code", "200");
      map.put("res_msg", "회원 정보 수정에 성공하였습니다.");
    }
    return map;
  }

  // 삭제
  @DeleteMapping("/delete")
  @ResponseBody
  public Map<String, Object> delete(@RequestBody Map<String, String> param, HttpSession session) {
    Map<String, Object> map = new HashMap<String, Object>();

    int result = loginService.delete(param.get("userid"));
    if (result == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "회원 탈퇴 중 오류가 발생하였습니다.");
    } else {
      
      Member loginUser = (Member) session.getAttribute("member");
      boolean isSelfDelete = param.get("userid").equals(loginUser.getUserId());

      if (loginUser != null && isSelfDelete) {
        session.invalidate();
      }
      
      map.put("res_code", "200");
      map.put("res_msg", "회원 탈퇴에 성공하였습니다.");
      map.put("isSelfDelete", isSelfDelete);
    }
    return map;
  }

  // 사용자 로그인 잠금 해제
  @PostMapping("resetStatus")
  @ResponseBody
  public Map<String, Object> resetStatus(@RequestBody Map<String, String> param) {
    Map<String, Object> map = new HashMap<String, Object>();

    int result = loginService.resetStatus(param.get("userid"));
    if (result == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "로그인 잠금 해제 중 오류가 발생하였습니다.");
    } else {
      map.put("res_code", "200");
      map.put("res_msg", "로그인 잠금 해제에 성공하였습니다.");
    }
    return map;
  }

  // 사용자 관리자 권한 부여
  @PostMapping("grantManager")
  @ResponseBody
  public Map<String, Object> grantManager(@RequestBody Map<String, String> param) {
    Map<String, Object> map = new HashMap<String, Object>();

    int result = loginService.grantManager(param.get("userid"));
    if (result == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "관리자 권한 부여 중 오류가 발생하였습니다.");
    } else {
      map.put("res_code", "200");
      map.put("res_msg", "관리자 권한 부여에 성공하였습니다.");
    }
    return map;
  }

  // 사용자 관리자 권한 해제
  @PostMapping("revokeManager")
  @ResponseBody
  public Map<String, Object> revokeManager(@RequestBody Map<String, String> param) {
    Map<String, Object> map = new HashMap<String, Object>();

    int result = loginService.revokeManager(param.get("userid"));
    if (result == 0) {
      map.put("res_code", "400");
      map.put("res_msg", "관리자 권한 해제 중 오류가 발생하였습니다.");
    } else {
      map.put("res_code", "200");
      map.put("res_msg", "관리자 권한 해제에 성공하였습니다.");
    }
    return map;
  }
  
}
