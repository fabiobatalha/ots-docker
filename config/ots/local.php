<?php

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
                'mailto' => 'email@email.org',
             )
        ),
        'grobid' => array(
            'jre' => 'java',
            'jre_args' => '-Xmx1024m',
            'install_path' => '/opt/grobid',
            'mode' => 'service', // valid values are service or batch
            'jarfile' => '/project/deps/grobid-0.5.1/grobid-core/build/libs/grobid-core-0.5.1-onejar.jar',   // located in <install_path>/grobid-core/target/
            'xsl' => 'module/GrobidConversion/assets/grobid-jats.xsl',
        ),
    ),
    'notification' => array(
        'adminEmail' => 'email@email.org',
    ),
    'doctrine' => array(
        'connection' => array(
            'orm_default' => array(
                'params' => array(
                    'host' => 'mysql',
                    'user' => 'xmlps',
                    'password' => 'xmlps',
                    'database' => 'xmlps'
                ),
            ),
        ),
    ),
    'log' => array(
        'level' => 7,
    ),
);