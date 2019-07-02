plan demo::deploy_apache(
  TargetSpec $nodes
) {
  apply_prep($nodes)

  apply($nodes, _run_as => 'root') {
    include apache

    file { '/var/www/html/index.html':
      ensure => 'file',
      source => "puppet:///modules/demo/site.html"
    }   
  }
}
