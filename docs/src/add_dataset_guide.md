<html><head></head><body><h2>How to Add a New Dataset to MLDatasets.jl</h2>
<p>Based on the process used to add AmazonComputers/AmazonPhoto (#249) and ZINC (#250).</p>
<h3>Step 1:Fork, clone, and set up upstream</h3>
<p>Fork <code>JuliaML/MLDatasets.jl</code> on GitHub, then:</p>
<pre><code class="language-bash">git clone https://github.com/YOUR_USERNAME/MLDatasets.jl
cd MLDatasets.jl
git remote add upstream https://github.com/JuliaML/MLDatasets.jl
git pull upstream master
git checkout -b add-your-dataset-name
</code></pre>
<p>Always work on a new branch — never commit directly to master.</p>
<h3>Step 2 : Write the dataset file</h3>
<p>Create <code>src/datasets/graphs/yourfile.jl</code> (or the appropriate category subfolder).</p>
<p><strong>The dataset file should contain the following components:</strong></p>
<ul>
<li><code>__init__&lt;n&gt;()</code> — registers download URLs and checksums with DataDeps</li>
<li>Dataset struct(s) inheriting <code>AbstractDataset</code></li>
<li>Constructor function</li>
<li><code>Base.length</code> and <code>Base.getindex</code></li>
<li>Docstring with description, arguments, examples, and a statistics table</li>
</ul>
<p><strong>Include <code>using</code> statements only for packages your file actually uses.</strong> Some dataset files need them (e.g. <code>amazon.jl</code> uses <code>using DataDeps</code>, <code>using NPZ</code>, <code>using SparseArrays</code>), others don't. Check existing files in <code>src/datasets/graphs/</code> to see what fits your case.</p>
<p><strong>What NOT to include</strong> — these are already defined by the module, adding them will cause errors:</p>
<pre><code class="language-julia">abstract type AbstractDataset end
struct Graph ... end
</code></pre>
<p>Also remove all test/debug code before the PR:</p>
<pre><code class="language-julia">println(...)
ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"
@assert ...
</code></pre>
<blockquote>
<p>💡 <strong>Local testing tip:</strong> During development it's useful to run your file standalone outside the module. You can temporarily add stub definitions for <code>AbstractDataset</code>, <code>Graph</code>, etc. at the top — just add a clear comment and remove them before opening the PR.</p>
</blockquote>
<h3>Step 3 : Add checksums (don't skip this)</h3>
<p>After downloading your dataset files, compute SHA256 for each:</p>
<pre><code class="language-bash">sha256sum file1.npz
sha256sum file2.npz
</code></pre>
<p>Add them to your <code>DataDep</code> registration:</p>
<pre><code class="language-julia">register(DataDep(
    "DatasetName",
    "...",
    ["url1", "url2"],
    hash = ["sha256-of-url1-file", "sha256-of-url2-file"]
))
</code></pre>
<blockquote>
<p>⚠️ <strong>Important:</strong> The order of hashes must exactly match the order of URLs. A mismatch causes DataDeps to prompt interactively during CI, which hangs the test process. This is one of the most common reasons first PRs fail CI.</p>
</blockquote>
<p>Do <strong>not</strong> use <code>ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"</code> in the dataset file — CI must rely on checksums instead.</p>
<h3>Step 4 :Register in the module</h3>
<p>Open <code>src/MLDatasets.jl</code>. Find where other graph datasets are included (search for <code>cora</code> or <code>pubmed</code>) and add your lines alongside them:</p>
<pre><code class="language-julia">include("datasets/graphs/yourfile.jl")
export YourDatasetName
</code></pre>
<p>Then find the <code>__init__()</code> function in the same file and add:</p>
<pre><code class="language-julia">__init__yourname()
</code></pre>
<h3>Step 5 : Add tests</h3>
<p>In <code>test/datasets/graphs.jl</code>, add a <code>@testset</code> block after the existing ones. Test that the dataset loads, node/edge counts match known values, and features have the correct shape. The exact assertions depend on your dataset.</p>
<h3>Step 6 : Add documentation</h3>
<p>In <code>docs/src/datasets/graphs.md</code>, add your dataset name inside the <code>@docs</code> block alongside the others. The documentation page auto-generates from your docstring — no extra writing needed.</p>
<h3>Step 7 : Commit and push</h3>
<pre><code class="language-bash">git add .
git commit -m "Add YourDatasetName graph dataset"
git push origin add-your-dataset-name
</code></pre>
<h3>Step 8 :Open the Pull Request</h3>
<p>Go to your fork on GitHub and click <strong>Compare &amp; Pull Request</strong>. Set the base to <code>JuliaML/MLDatasets.jl:master</code>.</p>
<p>In the PR description, link the relevant issue so it closes automatically on merge:</p>
<pre><code>Closes #&lt;issue_number&gt;
</code></pre>
<h3>Step 9 :CI</h3>
<p>GitHub Actions automatically runs tests on macOS, Ubuntu, Windows, and multiple Julia versions. All checks must pass before a maintainer will review. If something fails, expand the failing check log, fix it locally, and push again — the PR updates automatically and CI reruns.</p>


<hr>
<p><em>This guide is based on the contributor experience from #249 (AmazonComputers/AmazonPhoto) and #250 (ZINC).</em></p></body></html>
<p><em>This Closes #234.</em></p></body></html>
