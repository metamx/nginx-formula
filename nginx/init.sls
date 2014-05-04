nginx:
  pkg.installed:
    - name: nginx
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - pkg: nginx
