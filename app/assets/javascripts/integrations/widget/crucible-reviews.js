widgets['crucible-reviews'] = {
		//runs when we receive data from the job
		onData: function(el, data) {
				data.reviews.sort(function(a, b) {
					return a.username > b.username;
				});

				var firstTime = $('.content .user', el).length === 0;

				data.reviews.forEach(function(user) {
					if (firstTime) {
						var $user = $("<div class='user'></div>");
						var avatarUrl = data.baseUrl + "/avatar/" + user.username + "?s=60&redirect=false&" + new Date().getTime();
						var img = new Image();
						img.src = avatarUrl;
						img.alt = user.username;

						$user.append(img);
						$user.append("<div class='count' data-username='" + user.username + "'></div");
						$('.content', el).append($user);
					}

					$('.content .user .count[data-username=' + user.username + ']', el).text(user.openReviews);
				});

				$('.content', el).boxfit();
		}
};