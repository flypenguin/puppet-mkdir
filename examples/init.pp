node default {

  notify { 'before': }
  notify { 'after': }

  mkdir::p { '/a/b/c':
    require => Notify['before'],
    before  => Notify['after'],
  }
}
