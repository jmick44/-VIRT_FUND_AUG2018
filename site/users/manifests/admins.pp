class users::admins {

  users::managed_user { 'joe': }
  
  users::managed_user { 'sue':
    group => 'root',
  }
  
  users::managed_user { 'robert':
    group => 'wheel',
  }
}