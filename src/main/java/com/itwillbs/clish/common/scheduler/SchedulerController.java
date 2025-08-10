package com.itwillbs.clish.common.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import com.itwillbs.clish.myPage.service.MyPageService;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Controller
@AllArgsConstructor
public class SchedulerController {
	private final SchedulerService schedulerService;
	
//    @Scheduled(fixedDelay = 3000) // 작업 종료 후 3000ms(3초) 대기 후 재실행
//    public void printEvery3Seconds() {
//    	schedulerService.checkReservation();
//    	schedulerService.checkClassEndDate();
//    }
	
    // 매시 00분 15분 30분 45분 작동
    @Scheduled(cron = "0 */15 * * * ?")
    public void todoQuarterTime() {
    	schedulerService.checkReservation();
    	schedulerService.checkClassEndDate();
    }
    
    //매일 00시 작동
//    @Scheduled(cron = "*/15 * * * * ?")
    @Scheduled(cron = "0 0 0 * * ?")
    public void todoEveryDay() {
    	schedulerService.checkNotification();
    	schedulerService.checkEventDate();
    	schedulerService.toStartClass();
    }
    
    
    
}
