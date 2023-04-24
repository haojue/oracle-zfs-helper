#################################################
# Copyright 2017-2023 HaojueWang <acewhj@gmail.com>
# All Rights Reserved.
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#################################################
package ZFS;
use warnings;
use strict;
use Expect;
use vars qw(@ISA @EXPORT 
            );
@ISA    = qw(Exporter);
@EXPORT = qw(login 
             create_datalinks
             show_datalinks 
             create_interfaces
             show_interfaces 
             create_project 
             resize_project 
             show_project 
             show_projects 
             destroy_project
             create_lun
             destroy_lun
             show_lun
             create_initiator
             destroy_initiator
             show_initiators
             create_target
             destroy_target
             show_targets
             show_dashboard
             show_storagepool 
             close);


our $timeout = 10;
our $shell_prompt = ">";

##########################################################
#  login
##########################################################

sub login {
my $host = shift;
my $username = shift;
my $password = shift;
my $exp=Expect->spawn("ssh $host -l $username") or die "Cannot spawn ssh \n";

$exp->expect($timeout,
["connecting (yes/no)?", sub { my $self = shift;
                           $self->send("yes\n");
                           exp_continue; }],
["Password:", sub { my $self = shift;
                          $self->send("$password\n");
                            exp_continue; }],
              $shell_prompt);

return $exp;
}

##########################################################
#  create_datalinks 
##########################################################
sub create_datalinks {
my $exp = shift;
my $label = shift;
my $link = shift;
$exp->send("configuration net\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("datalinks\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("device\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set label=$label\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("set links=$link\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("set mtu=9000\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("commit\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}


##########################################################
#  show_datalinks 
##########################################################
sub show_datalinks {
my $exp = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("net\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("datalinks\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("done\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("done\n");
$exp->expect($timeout,[$shell_prompt] );
}

##########################################################
#  create_interfaces 
##########################################################
sub create_interfaces {
my $exp = shift;
my $label = shift;
my $link = shift;
my $ip = shift;
$exp->send("configuration net\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("interfaces\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ip\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set label=$label\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("set links=$link\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("set v4addrs=$ip\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("commit\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}


##########################################################
#  show_interfaces 
##########################################################
sub show_interfaces {
my $exp = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("net\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("interfaces\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("done\n");
$exp->expect($timeout,[$shell_prompt] );
$exp->send("done\n");
$exp->expect($timeout,[$shell_prompt] );
}


##########################################################
# create project 
##########################################################
sub create_project {
my $exp = shift;
my $name = shift;
my $size = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("project $name\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set quota=$size\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set reservation=$size\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("commit\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# resize project 
##########################################################
sub resize_project {
my $exp = shift;
my $name = shift;
my $size = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("select $name\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set quota=$size\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set reservation=$size\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("commit\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show project 
##########################################################
sub show_project {
my $exp = shift;
my $name = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("select $name\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show all projects
##########################################################
sub show_projects {
my $exp = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# destroy project 
##########################################################
sub destroy_project {
my $exp = shift;
my $name = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("destroy $name\n");
$exp->expect($timeout, ["(Y/N)"]);
$exp->send("y\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# create lun 
##########################################################
sub create_lun {
my $exp = shift;
my $name = shift;
my $pname = shift;
my $size = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("select $pname\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("lun $name\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set volsize=$size\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("commit\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# destroy lun 
##########################################################
sub destroy_lun {
my $exp = shift;
my $name = shift;
my $pname = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("select $pname\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("destroy $name\n");
$exp->expect($timeout, ["(Y/N)"]);
$exp->send("y\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show lun 
##########################################################
sub show_lun {
my $exp = shift;
my $name = shift;
my $pname = shift;
$exp->send("shares\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("select $pname\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("select $name\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show storagepool  
##########################################################
sub show_storagepool {
my $exp = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("storage\n");
$exp->expect($timeout, ["e>"]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# create initiator  
##########################################################
sub create_initiator {
my $exp = shift;
my $iname = shift;
my $alias = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("san\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("iscsi\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("initiators\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("create\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set initiator=$iname\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set alias=$alias\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("commit\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# destroy initiator  
##########################################################
sub destroy_initiator {
my $exp = shift;
my $iname = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("san\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("iscsi\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("initiators\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("destroy $iname\n");
$exp->expect($timeout, ["(Y/N)"]);
$exp->send("y\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show initiators  
##########################################################
sub show_initiators {
my $exp = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("san\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("iscsi\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("initiators\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# create target  
##########################################################
sub create_target {
my $exp = shift;
my $alias = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("san\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("iscsi\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("targets\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("create\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("set alias=$alias\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("commit\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# destroy target  
##########################################################
sub destroy_target {
my $exp = shift;
my $tname = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("san\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("iscsi\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("targets\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("destroy $tname\n");
$exp->expect($timeout, ["(Y/N)"]);
$exp->send("y\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show target  
##########################################################
sub show_targets {
my $exp = shift;
$exp->send("configuration\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("san\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("iscsi\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("targets\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("ls\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
$exp->send("done\n");
$exp->expect($timeout, [$shell_prompt]);
}

##########################################################
# show dashboard  
##########################################################
sub show_dashboard {
my $exp = shift;
$exp->send("status dashboard\n");
$exp->expect($timeout, [$shell_prompt]);
}


##########################################################
# close 
##########################################################
sub close {
my $exp = shift;
$exp->send("exit\n");
}
