-- Name: Nur Aisyah Bte Abdul Mutalib
-- Matric: U2110399H
-- Class Exercise 6

# Case: Socialgram

use socialgram;

-- 1.	List the names of users who are group moderators.

select `name`
from `user`
where UserID in(
	select UserId
    from `user-group`
    where isModerator = 'Y');

-- 2.	List the names of users who are banned in more than 1 group.

select `name`
from `user`
where exists(
	select UserID
	from `user-group`
    where isBanned = 'Y'
    and `user-group`.UserID = `user`.UserID
    group by isBanned
    having count(isBanned) > 1);

-- 3. 	List the names of users and total filesize of each user’s photos when the total filesize of his/her photos is larger than 1000.

select `name`, sum(filesize) as Total_Photo_Filesize
from `user`, photo, `user-photo`
where photo.PhotoID = `user-photo`.PhotoID
and `user-photo`.UserID = `user`.UserID
group by `name`
having sum(filesize) > 1000;

-- 4.	List the names of albums (and the number of users owning the album) in which at least one photo belongs to more than 1 users.

select AlbumName, count(distinct(UserID)) as total_users
from album
where PhotoID = (
	select PhotoID
    from `user-photo`
    where `user-photo`.PhotoID = album.PhotoID
    group by PhotoID
    having count(distinct(PhotoID)) >= 1)
group by AlbumName
having total_users > 1;



-- 5.	List the userid and user names of those who are following each other. For example, Ben Choi is following Jackie Tan and Jackie Tan is following Ben Choi.

# Reciprocal Relationship (Dyad)

select u3.UserID as userid, u4.`name` as userName, u3.FollowingUserID as following_userid, u5.`name` as following_userName
from `user` as u4, `user` as u5,
	(select u1.UserID, u1.FollowingUserID
    from `user-following` as u1 inner join `user-following` as u2
    on u1.UserID = u2.FollowingUserID
    and u1.FollowingUserID = u2.UserID) as u3
where u3.UserID = u4.UserID
and u3.FollowingUserID = u5.UserID
order by u3.UserID, u3.FollowingUserID desc;

-- 6.	List the users who are involved in relational triads. For example, Ben Choi is following Jayden Johnson, Jayden Johnson is following Cammy Soh, Cammy Soh is following Ben Choi. 

select distinct u1.name as user1, u2.Name as User2, u3.Name as User3
from user u1
join `user-following` f1 on u1.UserID = f1.FollowinguserID
join `user-following` f2 on f1.FollowinguserID = f2.userid
join user u2 on f2.FollowinguserID = u2.UserID
join `user-following` f3 on f2.FollowinguserID = f3.userid
join user u3 on f3.FollowinguserID = u3.UserID
join `user-following` on f3.FollowinguserID = f1.userid
order by user1; 

# Case: The Steps Challenge

use stepchallenge;

-- 1.	Retrieve a list of the names of participants. 

select `Name`
from participant;

-- 2.	List the names of all participants who have enrolled in more than 2 weekly challenges.

select `Name`
from participant
where exists(
	select ParticipantID, count(WeeklyChallengeID)
	from `participant-weeklychallenge`
    where `participant-weeklychallenge`.ParticipantID = participant.ParticipantID
    group by ParticipantID
    having count(WeeklyChallengeID) > 2);

-- 3.	What is the number of participants who have redeemed at least one “Car Wash at Caltex”?

select count(distinct(ParticipantID)) as PartAmt
from redemption
where RewardID = (
	select RewardID
	from reward
    where reward.RewardID = redemption.RewardID
    and RewardName = 'Car Wash at Caltex'
    group by RewardID
    having count(RewardID) >= 1);

-- 4.	List the names of participants who have accumulated more than 10,000 SC points and have redeemed at least one “Car Wash at Caltex”?  

select `Name`
from participant
where ParticipantID in(
	select distinct(ParticipantID)
    from redemption
    where RewardID = (
		select RewardID
		from reward
		where reward.RewardID = redemption.RewardID
		and RewardName = 'Car Wash at Caltex'
		group by RewardID
		having count(RewardID) >= 1))
and ParticipantID in(
	select distinct(ParticipantID)
    from scpoint
    where scpoint.ParticipantID = participant.ParticipantID
    group by ParticipantID
    having sum(BasicPointsEarned) > 10000);
        
