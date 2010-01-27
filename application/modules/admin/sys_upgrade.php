<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

//error_reporting(0);

class Sys_upgrade extends Controller {

    private $upgrade_server = 'http://test/upgrades/';

	public function __construct()
	{
		parent::Controller();

		$this->load->library('DX_Auth');

        if( $this->dx_auth->is_admin() == FALSE)
		{
			redirect('admin/login', '');
		}

		$this->load->library('lib_admin');
		$this->lib_admin->init_settings(); 
	}

    public function index()
    {
        // Show upgrade window;
        $this->template->show('sys_upgrade', FALSE);
    }

    public function make_upgrade()
    {
        if (!function_exists('ftp_connect'))
        {
            showMessage('Функция ftp_connect недоступна.');
            exit;
        }

        $this->load->library('ftp');
        $this->load->helper('string');
        $this->load->helper('file'); 

        $status = $this->_check_status();

        if ($status['is_update'] == TRUE AND $status['upgrade_file'] != '')
        {
            $upgrade_file = $status['upgrade_file'];
        }
        else
        {
            showMessage('Обновлений не нaйдено.');
            exit;
        }

        $path_to_index_php  =  $_POST['root_folder'];
        $config['hostname'] = $_POST['host'];
        $config['username'] = $_POST['login'];
        $config['password'] = $_POST['password'];
        $config['port']     = $_POST['port'];
        $config['passive']  = FALSE;
        $config['debug']    = FALSE;

        if ($this->ftp->connect($config) == FALSE)
        {
            showMessage('Ошибка подключения к серверу. Проверте имя пользователя или пароль.');
            exit;
        }
        
        $root = '/'.trim_slashes($path_to_index_php).'/';

        if ($root == '//') $root = '/';

        // Try to find self.
        $list = $this->ftp->list_files($root.'application/modules/core/');

        $error = TRUE;
        foreach($list as $k => $v)
        {
            if ($v == 'core'.EXT)
            {
                $error = FALSE;
            }
        }

        if ($error == TRUE)
        { 
            $this->ftp->close();
            showMessage('Ошибка. Не правильный путь к корневой директории.');
            exit;
        }
        else
        {
            // download zip archive
            $file = $this->upgrade_server.$upgrade_file;

            if(($fh = fopen($file, 'r')) == FALSE)
            {
                $this->ftp->close();
                showMessage('Ошибка загрузки файл обновлений.');
                exit;
            }
            else
            {
                $contents = stream_get_contents($fh);
                $tmp_folder = BASEPATH.'cache/'.time().'/';

                // Save file
                $tmp_file = BASEPATH.'cache/cms_upgrade.zip';

                if (file_exists($tmp_file))
                {
                    @unlink($tmp_file);
                }

                write_file($tmp_file, $contents);

                mkdir($tmp_folder);

                $this->load->library('pclzip', $tmp_file);

                if (($zip_result = $this->pclzip->extract(PCLZIP_OPT_PATH, $tmp_folder)) == 0)
                {
                    $this->ftp->close();

                    delete_files($tmp_folder, TRUE);
                    @rmdir($tmp_folder);
                    @unlink($tmp_file);

                    showMessage('Ошибка извлечения файлов из архива.');
                    exit;
                }

                // Update DB
                if (file_exists($tmp_folder.'migrations.php'))
                {
                    include($tmp_folder.'migrations.php');

                    if (function_exists('run_db_upgrade'))
                    {
                        run_db_upgrade();
                    }

                    @unlink($tmp_folder.'migrations.php');
                }

                $this->ftp->mirror($tmp_folder, $root);

                delete_files($tmp_folder, TRUE);
                @rmdir($tmp_folder);
                @unlink($tmp_file);

                $this->ftp->close();

                // Clear system cache
                $this->load->library('cache');
                $this->cache->delete_all();

                showMessage('Обновление завершено.');
                updateDiv('page', site_url('admin/dashboard/index'));
            }
        } 
    }

    public function _check_status()
    {
        $is_update    = FALSE;
        $upgrade_file = FALSE;

        if(($fh = fopen($this->upgrade_server.'migrates.xml', 'r')) == FALSE)
        {
            //die('Ошибка загрузки файла версий.');
            $is_update = FALSE;
        }
        else
        {
            $xml = stream_get_contents($fh); 

            $parser = xml_parser_create();
        	xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);
	        xml_parser_set_option($parser, XML_OPTION_SKIP_WHITE, 1);
    	    xml_parse_into_struct($parser, $xml, $vals);
    	    xml_parser_free($parser);

            foreach($vals as $k => $v)
            {
                if (isset($v['type']) AND isset($v['value']) AND isset($v['attributes']) )
                {
                    if ($v['type'] == 'complete' AND trim($v['value']) != '' AND trim($v['attributes']['id'] != ''))
                    {
                        if ($v['attributes']['id'] == IMAGECMS_NUMBER AND $v['value'] != '')
                        {
                            $is_update = TRUE;
                            $upgrade_file = trim($v['value']);
                        }
                    }
                }
            }
        }

        return array('is_update' => $is_update, 'upgrade_file' => $upgrade_file);
    }

}