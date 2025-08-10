/**
 * 
 */

/**  Opens sub-navigation on hover  마우스를 올리면 하위 탐색이 열립니다. */
window.onload = () => {
	
	const flexItem2 = document.querySelectorAll('.flex-item2');
	const subNav = document.getElementById('sub-nav');
	
	flexItem2.forEach(item => {
	    item.addEventListener('mouseenter', () => {
	        subNav.style.display = 'flex';
	    });
	});
	
	
	//flexItem2.addEventListener('mouseenter', () => {
	  //  subNav.style.display = 'flex';
	//});
	subNav.addEventListener('mouseenter', () => {
	    subNav.style.display = 'flex';
	});
	subNav.addEventListener('mouseleave', () => {
	    subNav.style.display = 'none';
	});
	
	(function() {
		let timer;
 		let count = 600;
//		let count = 10;
		
			function updateCountdown() {
				let minutes = Math.floor(count / 60);
				let seconds = count % 60;
				let displayCount = 
					(minutes < 10 ? "0" + minutes : minutes) + ":"
					+ (seconds < 10 ? "0" + seconds : seconds);
				$("#countdow").text(displayCount);
				if(count > 0) {
					count--;
					
				}
				else {
					
					clearInterval(timer);
				}
			
			}
		timer = setInterval(updateCountdown, 1000);
		updateCountdown();
		});
		
//		item.addEventListener('mouseleave', () => {
//	
//		});
//		const links = document.querySelectorAll('#flex-item2 > li > a');
//		const surroundings = document.querySelectorAll('body > *:not(#flex-item2)');
//		
//		links.forEach(link => {
//		  link.addEventListener('mouseenter', () => {
//		    surroundings.forEach(el => el.classList.add('blur-background'));
//		  });
//		
//		  link.addEventListener('mouseleave', () => {
//		    surroundings.forEach(el => el.classList.remove('blur-background'));
//		  });
//		});
		

}		

function logout() {
	// confirm() 함수 활용하여 "로그아웃하시겠습니까?" 질문을 통해
	if(confirm("로그아웃하시겠습니까?")) {
		location.href = "/logout";
		
	}

}


document.addEventListener("DOMContentLoaded", () => {
    const carousels = document.querySelectorAll(".carousel");

    carousels.forEach(carousel => {
        const track = carousel.querySelector(".carousel-track");
        const cards = track.querySelectorAll(".deconstructed-card");
        const prevBtn = carousel.querySelector(".carousel-button.prev");
        const nextBtn = carousel.querySelector(".carousel-button.next");
        const dotsContainer = carousel.querySelector(".dots-container");

        // Clear any existing dots to prevent duplicates
        if (dotsContainer) dotsContainer.innerHTML = "";

        // State for this carousel
        let currentIndex = 0;
        const cardWidth = cards[0]?.offsetWidth || 0;
        const cardMargin = 40;
        const totalCardWidth = cardWidth + cardMargin;

        // Create dots for this carousel
        const dots = [];
        cards.forEach((_, index) => {
            const dot = document.createElement("div");
            dot.classList.add("dot");
            if (index === 0) dot.classList.add("active");
            dot.addEventListener("click", () => goToCard(index));
            dotsContainer && dotsContainer.appendChild(dot);
            dots.push(dot);
        });

        function goToCard(index) {
            index = Math.max(0, Math.min(index, cards.length - 1));
            currentIndex = index;
            updateCarousel();
        }

        function updateCarousel() {
            const translateX = -currentIndex * totalCardWidth;
            track.style.transform = `translateX(${translateX}px)`;
            dots.forEach((dot, index) => {
                dot.classList.toggle("active", index === currentIndex);
            });
        }

        if (prevBtn) {
            prevBtn.addEventListener("click", () => {
                goToCard(currentIndex - 1);
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener("click", () => {
                goToCard(currentIndex + 1);
            });
        }

//         Optional: Keyboard navigation per carousel (if desired)
         carousel.addEventListener("keydown", (e) => {
             if (e.key === "ArrowLeft") goToCard(currentIndex - 1);
             else if (e.key === "ArrowRight") goToCard(currentIndex + 1);
         });

        // Touch support per carousel
        let touchStartX = 0;
        let touchEndX = 0;

        track.addEventListener("touchstart", (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });

        track.addEventListener("touchend", (e) => {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
        });

        function handleSwipe() {
            if (touchStartX - touchEndX > 50) {
                goToCard(currentIndex + 1);
            } else if (touchEndX - touchStartX > 50) {
                goToCard(currentIndex - 1);
            }
        }

        // Responsive: update card width on resize
        window.addEventListener("resize", () => {
            const newCardWidth = cards[0]?.offsetWidth || 0;
            const newTotalCardWidth = newCardWidth + cardMargin;
            const translateX = -currentIndex * newTotalCardWidth;
            track.style.transition = "none";
            track.style.transform = `translateX(${translateX}px)`;
            setTimeout(() => {
                track.style.transition = "transform 0.6s cubic-bezier(0.16, 1, 0.3, 1)";
            }, 50);
        });

        updateCarousel();
    });
});

