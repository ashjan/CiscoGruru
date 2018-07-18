<?php
if (session_id() == "")
    session_start(); // Initialize Session data

if(isset($_SESSION["consultant_status_UserID"])){
    header("Location: index.php");
    exit;
}

?>

<!DOCTYPE html>
<html lang="en">
<?php include("head.php"); ?>
<?php 
	if( !class_exists('csubcontractor_db')){
		include("admin/ewdbhelper12.php");
		$db = new csubcontractor_db();
	}
	/////////////////////////////////////////////////// 
?>
<body class="bdygradiant">
<!-- Notification-->
<?php include("notification.php"); ?>

<!-- above nav-->
<?php include("topnav.php"); ?>

<!-- Header section-->
<?php include("navigation.php"); ?>
<?php //include("navbelow.php"); ?>
<br/>

<!-- Page Content -->
<div class="container panel panel-body">
   <div class="page-header text-center">
    <h1>Sign Up  - it's free</h1>
  </div>
  
  <!-- Pricing Tables - START --><br>
<div class="row">
    <div class="col-md-4">
      <div class="panel panel-part ">
		<div class="panel-icon">
			<img src="app/resource/img/Partnersicon.png" alt="" />
		</div>
        <div class="panel-heading">
          <h4 class="text-center"><strong>Partners</strong></h4>
        </div>
        <div class="panel-body panel-marg text-center">
          <h3> <small><b>Companies with a pool of consultants</b></small> </h3>
        </div>
		<div class="panel-footer panel-marg text-center"><a href="create_contractor_account.php" class="btn button btn-primary">Sign Up</a> </div>
        <ul class="list-group list-group-flush">
          <li class="list-group-item"> Manage a team of 3 members </li><hr />
          <li class="list-group-item"> Submit your cosultant's applications against projects </li><hr />
          <li class="list-group-item"> Application status notifications </li><hr />
          <!--<li class="list-group-item"> Job Placement </li><hr />-->
        </ul>
      </div>
    </div>
    <div class="col-md-4">
      <div class="panel panel-part">
		<div class="panel-icon">
			<img  src="app/resource/img/Consultantsicon.png" alt="" />
		</div>
        <div class="panel-heading">
          <h4 class="text-center"><strong>Consultants</strong></h4>
        </div>
        <div class="panel-body panel-marg  text-center">
          <h3><small><b> Who provide solutions to business problems</b></small></h3>
        </div>
		<div class="panel-footer text-center"> <a href="create_consultant_account.php" class="btn button btn-primary">Sign Up</a> </div>
        <ul class="list-group list-group-flush">
          <li class="list-group-item"> Personalized dashboard </li><hr />
          <li class="list-group-item"> Public Profile </li><hr />
          <li class="list-group-item"> Relevant project suggestions </li><hr />
          <li class="list-group-item"> Keep multiple resumes and portfolios </li><hr />
		  <li class="list-group-item"> Application status Alert </li><hr />
		  <li class="list-group-item"> Personal assessment </li><hr />		  
        </ul>
        
      </div>
    </div>
    <div class="hide col-md-3">
      <div class="panel panel-success">
        <div class="panel-heading">
          <h4 class="text-center"><strong>Managing Consultants</strong></h4>
        </div>
        <div class="panel-body text-center">
          <h3> <strong>Skill Management</strong> </h3>
        </div>
        <ul class="list-group list-group-flush">
          <li class="list-group-item"> Create profile </li><hr />
          <li class="list-group-item"> Bonuses on placements </li><hr />
          <li class="list-group-item"> Promote your resume </li><hr />
          <li class="list-group-item"> Recruiter support </li><hr />
        </ul>
        <div class="panel-footer"> <a href="create_consultant_account.php" class="btn btn-lg btn-block btn-success">Sign Up</a> </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="panel panel-part">
		<div class="panel-icon">
			<img src="app/resource/img/PPicon.png" alt="" />
		</div>
        <div class="panel-heading">
          <h4 class="text-center"><strong>Prime Partners</strong></h4>
        </div>
        <div class="panel-body text-center panel-marg ">
          <h3><small><b>Top 20 consulting companies that provide solutions to business problems</b></Small></h3>
        </div>
		 <div class="panel-footer text-center"> <a href="register" class="btn  button btn-primary">Sign Up</a> </div>
        <ul class="list-group list-group-flush">
          <li class="list-group-item"> Company public profile </li><hr />
          <li class="list-group-item"> Team of 5 recruiters </li><hr />
          <li class="list-group-item"> Application alerts </li><hr />
          <li class="list-group-item"> Favorite consultants list </li><hr />
		  <li class="list-group-item"> Applicant history with prime partner </li><hr />
		  <li class="list-group-item"> Recruiters comments from previous interactions </li><hr />
        </ul>
       <!-- <div class="panel-footer"> <a class="btn btn-lg btn-block btn-info">Coming Soon!</a> </div> -->
       
      </div>
    </div>
  </div>
  <!-- Pricing Tables - END --> 
  
   
  
</div>
<!-- /.container -->
<br>
<br>

<?php include("footersection.php"); ?>
<?php include("bottomjs.php") ?>
</body>
</html>
