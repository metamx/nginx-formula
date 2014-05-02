{% set nginx  = pillar.get('nginx', {}) -%}
{% set htauth = nginx.get('htpasswd', '/etc/nginx/.htpasswd') -%}
{% set htpasswd = salt['grains.filter_by']({
  'Debian': 'apache2-utils',
  'RedHat': 'httpd-tools',
  'default': 'Debian'}) %}

htpasswd:
  pkg.installed:
    - name: {{ htpasswd }}

{% for name, user in pillar.get('users', {}).items() %}
{% if user['webauth'] is defined -%}

nginx_user_{{name}}:
  module.run:
    - name: basicauth.adduser
    - user: {{ name }}
    - passwd: {{ user['webauth'] }}
    - path: {{ htauth }}
    - require:
      - pkg: htpasswd

{% endif -%}
{% endfor %}
