
// package com;
// import java.util.ArrayList;
// import java.util.List;
// import java.util.Optional;

// import com.hamonize.portal.user.ROLE;
// import com.hamonize.portal.user.SecurityUser;
// import com.hamonize.portal.user.User;
// import com.hamonize.portal.user.UserRepository;

// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.security.core.GrantedAuthority;
// import org.springframework.security.core.authority.SimpleGrantedAuthority;
// import org.springframework.security.core.userdetails.UserDetailsService;
// import org.springframework.security.core.userdetails.UsernameNotFoundException;
// import org.springframework.stereotype.Service;

// import lombok.RequiredArgsConstructor;

// @Service
// @RequiredArgsConstructor
// public class SecurityUserDetailsService implements UserDetailsService{
//     private Logger logger = LoggerFactory.getLogger(this.getClass());

//     @Autowired
//     UserRepository ur;

//     @Override
//     public SecurityUser loadUserByUsername(String userid) throws UsernameNotFoundException {
//         logger.info("SecurityUserDetailsService >>>>  ");
//         Optional<User> user = ur.findByUserid(userid);
//         List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
//         grantedAuthorities.add(new SimpleGrantedAuthority(ROLE.USER.getValue()));
        

//         return new SecurityUser(user.get());
//     }
    
// }
