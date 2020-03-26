name "fluentd_files"

default_version "1.0.0"

license :project_license
skip_transitive_dependency_licensing true

# This software setup fluentd related files, e.g. etc files.
# Separating files into fluentd.rb and fluentd-files.rb is for speed up package building

build do
  block do
    # setup related files
    pkg_type = project.packagers_for_system.first.id.to_s
    root_path = "/" # for ERB
    install_path = project.install_dir # for ERB
    project_name = project.name # for ERB
    project_name_snake = project.name.gsub('-', '_') # for variable names in ERB
    rb_major, rb_minor, rb_teeny = project.overrides[:ruby][:version].split("-", 2).first.split(".", 3)
    gem_dir_version = "#{rb_major}.#{rb_minor}.0" # gem path's teeny version is always 0
    install_message = nil

    template = ->(*parts) { File.join('templates', *parts) }
    generate_from_template = ->(dst, src, erb_binding, opts={}) {
      mode = opts.fetch(:mode, 0755)
      destination = dst.gsub('fluentd', project.name)
      FileUtils.mkdir_p File.dirname(destination)
      File.open(destination, 'w', mode) do |f|
        f.write ERB.new(File.read(src), nil, '<>').result(erb_binding)
      end
    }

    if File.exist?(template.call('INSTALL_MESSAGE'))
      install_message = File.read(template.call('INSTALL_MESSAGE'))
    end

    # copy pre/post scripts into omnibus path (./package-scripts/fluentd)
    FileUtils.mkdir_p(project.package_scripts_path)
    Dir.glob(File.join(project.package_scripts_path, '*')).each { |f|
      FileUtils.rm_f(f) if File.file?(f)
    }

    # templates/package-scripts/fluentd/xxxx/* -> ./package-scripts/fluentd
    Dir.glob(template.call('package-scripts', 'fluentd', pkg_type, '*')).each { |f|
      package_script = File.join(project.package_scripts_path, File.basename(f))
      generate_from_template.call package_script, f, binding, mode: 0755
    }

    systemd_file_path = File.join(project.resources_path, 'etc', 'systemd', project.name + ".service")
    template_path = template.call('etc', 'systemd', 'fluentd.service.erb')
    if File.exist?(template_path)
      generate_from_template.call systemd_file_path, template_path, binding, mode: 0755
    end

    # setup /etc/fluentd
    ['fluent.conf.tmpl', ['logrotate.d', 'fluentd.logrotate'], ['prelink.conf.d', 'fluentd.conf']].each { |item|
      conf_path = File.join(project.resources_path, 'etc', 'fluentd', *([item].flatten))
      generate_from_template.call conf_path, template.call('etc', 'fluentd', *([item].flatten)), binding, mode: 0644
    }

    ["fluentd"].each { |command|
      sbin_path = File.join(install_path, 'usr', 'sbin', command)
      # templates/usr/sbin/yyyy.erb -> INSTALL_PATH/usr/sbin/yyyy
      generate_from_template.call sbin_path, template.call('usr', 'sbin', "#{command}.erb"), binding, mode: 0755
    }

    FileUtils.remove_entry_secure(File.join(install_path, 'etc'), true)
    # ./resources/etc -> INSTALL_PATH/etc
    FileUtils.cp_r(File.join(project.resources_path, 'etc'), install_path)
  end
end
