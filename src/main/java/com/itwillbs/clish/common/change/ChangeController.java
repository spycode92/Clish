package com.itwillbs.clish.common.change;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/change")
public class ChangeController {
	
	private final ChangeService changeService;
	
	@PostMapping("/resetPassword")
	@ResponseBody
	public Map<String, Object> resetPassword(
			@RequestParam String userId, @RequestParam String userEmail, @RequestParam String newPasswd) {
	    Map<String, Object> result = new HashMap<>();
	    boolean success = changeService.resetPassword(userId, userEmail, newPasswd);
	    result.put("success", success);
	    return result;
	}
}
