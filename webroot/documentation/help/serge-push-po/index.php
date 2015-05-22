<?php
    $command = 'serge-push-po';
    include($_SERVER['DOCUMENT_ROOT'] . '/../inc/help-header.php');
?>


<h1 id="NAME">NAME</h1>

<p>serge-push-po - Push .po files to translation server</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p><code>serge push-po &lt;configuration-files&gt; [--force] [--echo-commands] [--echo-output]</code></p>

<p>Where <code>&lt;configuration-files&gt;</code> is a path to a specific .serge file, or a directory to scan .serge files in. You can specify multiple paths as separate command-line parameters.</p>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Based on each configuration file&#39;s <b>job</b> section, push .po files to remote translation server.</p>

<h1 id="OPTIONS">OPTIONS</h1>

<dl>

<dt><b>--force</b></dt>
<dd>

<p>Instruct the remote party to skip any optimizations and force supdate data from all .po files.</p>

</dd>
<dt><b>--echo-commands</b></dt>
<dd>

<p>Echo system commands about to be executed (useful for debugging)</p>

</dd>
<dt><b>--echo-output</b></dt>
<dd>

<p>Echo commands&#39; output (useful for debugging)</p>

</dd>
</dl>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<p>Part of <a href="../serge/">serge</a> suite.</p>


<?php include($_SERVER['DOCUMENT_ROOT'] . '/../inc/help-footer.php') ?>
