<?php

$NOTIFICATION_EMAIL = getenv('NOTIFICATION_EMAIL') ?: 'mail@mail.com';
$CROSSREF_EMAIL = getenv('CROSSEREF_EMAIL') ?: $NOTIFICATION_EMAIL;
$MYSQL_HOST = getenv('MYSQL_HOST') ?: 'mysql';
$MYSQL_PORT = getenv('MYSQL_PORT') ?: '3306';
$MYSQL_USER = getenv('MYSQL_USER') ?: 'xmlps'; 
$MYSQL_PASSWORD = getenv('MYSQL_PASSWORD') ?: 'xmlps';
$MYSQL_DATABASE = getenv('MYSQL_DATABASE') ?: 'xmlps';

return array(
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions' => true,
    ),
    'modules' => array(
        'ZendDeveloperTools',
    ),
    'conversion' => array(
        'docx' => array(
            'unoconv' => array(
                'command' => 'HOME=/tmp unoconv',
            ),
        ),
        'references' => array(
            'crossref_api' => array(
                'endpoint' => 'https://search.crossref.org/dois',
                'score_threshold' => 1,
                'mailto' => $CROSSREF_EMAIL,
             )
        ),
        'grobid' => array(
            'jre' => 'java',
            'jre_args' => '-Xmx1024m',
            'install_path' => '/project/deps/grobid-0.5.1',
            'mode' => 'service', // valid values are service or batch
            'jarfile' => 'grobid-core-0.5.1-onejar.jar',   // located in <install_path>/grobid-core/target/
            'xsl' => 'module/GrobidConversion/assets/grobid-jats.xsl',
        ),
    ),
    'notification' => array(
        'adminEmail' => $NOTIFICATION_EMAIL,
    ),
    'doctrine' => array(
        'connection' => array(
            'orm_default' => array(
                'params' => array(
                    'host' => $MYSQL_HOST,
                    'user' => $MYSQL_USER,
                    'password' => $MYSQL_PASSWORD,
                    'dbname' => $MYSQL_DATABASE,
                    'port' => $MYSQL_PORT
                ),
            ),
        ),
    ),
    'log' => array(
        'level' => 7,
    ),
);