$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'vagrancy'
run Vagrancy::App
