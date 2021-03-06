{# Variables
# @var model
# @var editProductUrl
# @var jsCode
#}

{$jsCode}

{$forCompareProducts = $CI->session->userdata('shopForCompare')}
{$cart_data= ShopCore::app()->SCart->getData();}

<script type="text/javascript">
    var currentProductId = '{echo $model->getId()}';
</script>
<!-- BEGIN STAR RATING -->
<link rel="stylesheet" type="text/css" href="{$SHOP_THEME}js/rating/jquery.rating-min.css" />
<script src="{$SHOP_THEME}js/rating/jquery.rating-min.js"></script>
<script src="{$SHOP_THEME}js/rating/jquery.MetaData-min.js"></script>
<script src="{$SHOP_THEME}js/product.js"></script>


<!-- BEGIN LIGHTBOX -->
<script type="text/javascript" src="{$SHOP_THEME}js/lightbox/scripts/jquery.color.min.js"></script>
<script type="text/javascript" src="{$SHOP_THEME}js/lightbox/scripts/jquery.lightbox.min.js"></script>
<!-- END LIGHTBOX -->


<div class="content">    
    <div class="center">
        <div class="tovar_frame clearfix{if $model->firstvariant->getstock()== 0} not_avail{/if}">
            <div class="thumb_frame f_l">
                {if sizeof($model->getSProductImagess()) > 0}
                    {foreach $model->getSProductImagess() as $image}
                        <span>
                            <a  class="grouped_elements" rel="gal1" href="{echo $image->getThumbUrl()}">                         
                                <img src="{echo $image->getThumbUrl()}" width="90"/>
                            </a>                                
                        </span>
                    {/foreach}
                {/if}                
            </div>
            <div class="photo_block">
                <a class="grouped_elements" rel="gal1" href="{productImageUrl($model->getMainImage())}">
                    <img src="{productImageUrl($model->getMainImage())}"/>
                </a>
            </div>
            <div class="func_description">
                <div class="crumbs">
                    {renderCategoryPath($model->getMainCategory())}
                </div>
                <h1>{echo ShopCore::encode($model->getName())}</h1>
                <div class="f-s_0">
                    <span class="code">Код: {echo $model->firstvariant->getNumber()}</span>
                    <div class="di_b star">
                        {$rating = $model->getRating()}
                        <input class="hover-star" type="radio" name="rating-1" value="1" {if $rating==1}checked="checked"{/if}/>
                        <input class="hover-star" type="radio" name="rating-1" value="2" {if $rating==2}checked="checked"{/if}/>
                        <input class="hover-star" type="radio" name="rating-1" value="3" {if $rating==3}checked="checked"{/if}/>
                        <input class="hover-star" type="radio" name="rating-1" value="4" {if $rating==4}checked="checked"{/if}/>
                        <input class="hover-star" type="radio" name="rating-1" value="5" {if $rating==5}checked="checked"{/if}/>
                    </div>
                    <a href="#" class="response">{echo $model->totalComments()} {echo SStringHelper::Pluralize($model->totalComments(), array('отзыв', 'отзывы', 'отзывов'))}</a>
                    <div class="social_small di_b">
                        <a href="#" class="facebook"></a>
                        <a href="#" class="vkontakte"></a>
                        <a href="#" class="twitter"></a>
                        <a href="#" class="mail"></a>
                    </div>
                </div>
                <div class="buy clearfix">


                    <div class="price f-s_26">{echo $model->firstVariant->toCurrency()} 
                        <sub>{$CS}</sub>
                        <span class="d_b">{echo $model->firstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span>
                    </div>
                    <div class="in_cart"></div>
                    {if $model->firstvariant->getstock()== 0}
                        <div class="in_cart">Нет в наличии</div>
                        <div class="buttons button_big_greys f_l">
                            <a href="" class="goNotifMe" data-prodid="{echo $model->getId()}" data-varid="{echo $model->firstvariant->getId()}">Сообщить о появлении</a>
                        </div>
                    {else:}
                        {if !is_in_cart($model->getId())}
                            <div class="buttons button_big_green f_l"> 
                                <a href="" class="goBuy" data-prodid="{echo $model->getId()}" data-varid="{echo $model->firstVariant->getId()}" >Купить</a>
                            </div>
                        {else:}
                            <div class="in_cart">Уже в корзине</div>
                            <div class="buttons button_big_blue f_l">
                                <a href="/shop/cart" data-prodid="{echo $model->getId()}" data-varid="{echo $model->firstvariant->getId()}">Оформить заказ</a>
                            </div>
                        {/if}
                    {/if}
                    <div class="f_l">
                        <span class="ajax_refer_marg">
                            {if $forCompareProducts && in_array($model->getId(), $forCompareProducts)}
                                <a href="{shop_url('compare')}">Сравнить</a>
                            {else:}
                                <a href="{shop_url('compare/add/'. $model->getId())}" data-prodid="{echo $model->getId()}" class="js gray toCompare">Добавить к сравнению</a>
                            {/if}
                        </span>
                        <span>
                            {if !is_in_wish($model->getId())}
                            <a data-logged_in="{if ShopCore::$ci->dx_auth->is_logged_in()===true}true{/if}" data-varid="{echo $model->firstVariant->getId()}" data-prodid="{echo $model->getId()}" href="#" class="js gray addToWList">Сохранить в список желаний</a>
                            {else:}
                                <a href="/shop/wish_list">Уже в списке желаний</a>
                            {/if}</span>
                    </div>
                </div>
                <p class="c_b">{echo $model->getShortDescription()}</p>
                <p>{echo ShopCore::app()->SPropertiesRenderer->renderPropertiesInline($model)}</p>
                <div><img src="{$SHOP_THEME}images/temp/SOCIAL_like.png"/></div>
            </div>
        </div>
        <ul class="info_buy">
            <li>
                <img src="{$SHOP_THEME}images/order_phone.png">
                <div>
                    <div class="title">Заказ по телефону:</div>
                    <span></span>
                    <span></span> 
                    <span></span>
                </div>
            </li>
            <li>
                <img src="{$SHOP_THEME}images/buy.png">
                <div>
                    <div class="title">Оплата <span><a href="/oplata">(узнать больше)</a></span></div>
                    {foreach $payment_methods as $methods}
                        <span class="small_marker">{echo $methods.name}</span>
                    {/foreach}
                </div>
            </li>
            <li>
                <img src="{$SHOP_THEME}images/deliver.png">
                <div>
                    <div class="title">Доставка <span><a href="/dostavka">(узнать больше)</a></span></div>
                    {foreach $delivery_methods as $methods}
                        <span class="small_marker">{echo $methods.name}</span>
                    {/foreach}
                </div>
            </li>
        </ul>
    </div>



<!-----------------------------------------------------------------------Акционное предложение начало-->

    {if $model->getKits()->count() > 0}
        {echo '<pre>';}
        {$tir = $model->getKits()}
        {foreach $tir as $ti}
            {echo '<pre>';}
            {echo $ti}
            {echo '</pre>';}
        {/foreach}

        {echo '</pre>';}
        {$kits = $model->getKits()}
        {# Display the list of product kits #}
        <div class="f-s_18 c_6 center">Акционное предложение</div>
        <div class="promotion carusel_frame">
            <div class="carusel">

                <ul>
                    <li>
                        {$count = count($kits[0]->getShopKitProducts())}
                       
                            {$kitt = $kits[0]->getShopKitProducts();}
                            {foreach $kitt as $tr}
                            {echo '<pre>';}
                            {echo $tr}
                            {echo '</pre>';}
                            {/foreach}
                        

                        <div class="f_l smallest_item">
                            <div class="photo_block">
                                <a href="{shop_url('shop/product'. $model->getId())}">
                                    <img src="{productImageUrl($model->getSmallModImage())}" />
                                </a>
                            </div>
                            <div class="func_description">
                                <a href="{'/shop/product/'.$model->getId()}">{echo ShopCore::encode($model->getName())}</a>
                                <div class="buy">

                                    <div class="price f-s_16 f_l">{echo $model->firstVariant->toCurrency()} 
                                        <sub>{$CS}</sub>
                                        <span class="d_b">{echo $model->firstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span>
                                    </div>

                                </div>
                            </div>
                            <div class="plus_eval">+</div>
                            {$i = 0}
                            {$sum1_1 = $sum2_1 = $model->firstVariant->toCurrency()}
                            {$sum1_2 = $sum2_2 = $model->firstVariant->toCurrency('Price', 1)}
                            {foreach $kits[0]->getShopKitProducts() as $shopKitProduct}

                                {$ap = $shopKitProduct->getSProducts()}
                                {$ap->setLocale(ShopController::getCurrentLocale())}


                                <div class="f_l smallest_item">
                                    <div class="photo_block">
                                        <a href="{'/shop/product/'.$ap->getUrl()}">
                                            <img src="/uploads/shop/{echo $ap->getId()}_small.jpg" />
                                        </a>
                                    </div>
                                        
                                    <div class="func_description">
                                        <a href="{'/shop/product/'.$ap->getId()}">{echo ShopCore::encode($ap->getName())}</a>
                                        
                                        <div class="buy">
                                           
                                            {$kitFirstVariant = $ap->getKitFirstVariant($shopKitProduct)}
                                            {if $shopKitProduct->getDiscount()}

                                                <del class="price f-s_12 price-c_9">{echo $s1_1 = $kitFirstVariant->toCurrency()}<sub> {$CS}</sub>
                                                    <span>{echo $s1_2 = $kitFirstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span></del>


                                                <div class="price f-s_14 price-c_red">{echo $s2_1 = (int)$kitFirstVariant->toCurrency()*(100-$shopKitProduct->getDiscount())/100}<sub> {$CS}</sub><span>{echo $s2_2 = (int)$kitFirstVariant->toCurrency('Price', $NextCSId)*(100-$shopKitProduct->getDiscount())/100} {$NextCS}</span></div>

                                            {else:}
                                                <div class="price f-s_14">{echo $kitFirstVariant->toCurrency()}<sub> {$CS}</sub><span>{echo $kitFirstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span></div>   
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                                {$sum1_1 += $s1_1}
                                {$sum1_2 += $s1_2}
                                {$sum2_1 += $s2_1}
                                {$sum2_2 += $s2_2}
                                {$i++}
                                
                                {if $i == $count}        
                                    <div class="plus_eval">=</div>
                                    <div class="button_block">
                                        <div class="buy">
                                            {if $dis}
                                               
                                                <del class="price f-s_12 price-c_9">{$sum1_1}<sub> {$CS}</sub><span>{echo $sum1_2} {$NextCS}</span></del>

                                            {/if}
                                            <div class="price f-s_18">{echo $sum2_1} <sub> {$CS}</sub><span> {echo $sum2_2}  {$NextCS}</span></div>
                                        </div>
                                        <div class="buttons button_gs">
                                            <div class="buy">

                                       {foreach $kits as $kit}
                                     
                                       <a class="goBuy" kitId="{echo $kit->id}" instance="ShopKit" data-varid="86" data-prodid="{echo $kit->productId}" href="">Купить</a>
                            {/foreach}
                                            </div>
                                        </div>
                                    </div>
                                {else:}
                                    <div class="plus_eval">+</div>
                                {/if}
                            {/foreach}				
                    </li>
                </ul>

            </div>
            <button class="prev"></button>
            <button class="next"></button>
        </div> 
    {/if}
<!------------------------------------------------------------------------------------------------------------Finish-->

    {if count(getSimilarProduct($model, 20))>0}
        <div class="featured carusel_frame">
        <div class="f-s_18 c_6 center">Похожие товары</div>
            <div class="carusel">
                <ul>
                        {$simprod = getSimilarProduct($model, 20)}
                        {foreach $simprod as $sp}
                            {$style = productInCart($cart_data, $sp->getId(), $sp->firstVariant->getId(), $sp->firstVariant->getStock())}
                            <li>
                                <div class="f_l smallest_item {if $sp->firstvariant->getstock()==0}not_avail{/if}">
                                    <div class="photo_block">
                                        <a href="{site_url('shop/product/'.$sp->getId())}">
                                            <img src="{productImageUrl($sp->getSmallModImage())}"/>
                                        </a>
                                    </div>
                                    <div class="func_description">
                                        <a href="{site_url('shop/product/'.$sp->getId())}" class="title">{echo ShopCore::encode($sp->getName())}</a>
                                        <div class="buy">
                                            <div class="price f-s_14">{echo $sp->firstVariant->toCurrency()}<sub> {$CS}</sub><span>{echo $sp->firstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span> </div>                                                                             
                                            <div class="{$style.class} buttons">                                            
                                                <a class="{$style.identif}" href="{$style.link}" data-varid="{echo $sp->firstVariant->getId()}"  data-prodid="{echo $sp->getId()}" >{$style.message}</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        {/foreach}
                </ul>
            </div>
            <button class="prev"></button>
            <button class="next"></button>
        </div>
    {/if} 

    <div class="center">
        <div class="tabs f_l w_770 info_tovar">
            <ul class="nav_tabs">
                {if $model->getFullDescription()}
                    <li><a href="#first">Информация</a></li>
                {/if}
                {if ShopCore::app()->SPropertiesRenderer->renderPropertiesTable($model)}
                    <li><a href="#second">Характеристики</a></li>
                {/if}
                {if $model->getRelatedProductsModels()}
                    <li><a href="#third">Аксессуары</a></li>
                {/if}
                <li><a href="#four">{echo SStringHelper::Pluralize($model->totalComments(), array('Отзыв', 'Отзывы', 'Отзывов'))}({echo $model->totalComments()})</a></li>
            </ul>
            {if $model->getFullDescription()}
                <div id="first">
                    <div class="info_text">
                        {echo $model->getFullDescription()}
                    </div>
                </div>
            {/if}
            {if ShopCore::app()->SPropertiesRenderer->renderPropertiesTable($model)}
                <div id="second">
                    {echo ShopCore::app()->SPropertiesRenderer->renderPropertiesTable($model)}
                </div>
            {/if}
            {if $model->getRelatedProductsModels()}
                <div id="third">
                    <ul class="accessories f-s_0">
                        {foreach $model->getRelatedProductsModels() as $p} 
                            {$style = productInCart($cart_data, $p->getId(), $p->firstVariant->getId(), $p->firstVariant->getStock())}
                            <li>
                                <div class="small_item">
                                    <a class="img" href="{shop_url('product/' . $p->getUrl())}">
                                        <span><img src="{productImageUrl($p->getSmallModImage())}" /></span>
                                    </a>
                                    <div class="info">
                                        <a href="{shop_url('product/'.$p->getUrl())}" class="title">{echo ShopCore::encode($p->getName())}</a>
                                        <div class="buy">
                                            <div class="price f-s_16 f_l">{echo $p->firstVariant->toCurrency()}<sub> {$CS}</sub><span class="d_b">{echo $p->firstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span></div>
                                            <div class="{$style.class} buttons"><a class="{$style.identif}" href="{$style.link}" data-varid="{echo $p->firstVariant->getId()}" data-prodid="{echo $p->getId()}" >{$style.message}</a></div> 
                                        </div>
                                    </div>
                                </div>
                            </li>
                        {/foreach}    
                    </ul>
                </div>

            {/if}
            <div id="four">
                {$comments}
            </div>
        </div>
        <div class="nowelty_auction m-t_29">
            <div class="box_title">
                <span>Новинки</span>
            </div>
            <ul>                  
                {foreach getPromoBlock('hot', 3) as $hotProduct}                                     
                    {$style = productInCart($cart_data, $hotProduct->getId(), $hotProduct->firstVariant->getId(), $hotProduct->firstVariant->getStock())}
                    <li>
                        <div class="small_item">
                            <a href="{shop_url('product/' . $hotProduct->getUrl())}" class="img">
                                <span>
                                    <img src="{productImageUrl($hotProduct->getSmallModimage())}" alt="{echo ShopCore::encode($hotProduct->getName())}" />
                                </span>
                            </a>
                            <div class="info">
                                <a href="{shop_url('product/' . $hotProduct->getUrl())}" class="title">{echo ShopCore::encode($hotProduct->getName())}</a>
                                <div class="buy">
                                    <div class="price f-s_16 f_l">{echo $hotProduct->firstVariant->toCurrency()} <sub>{$CS}</sub><span class="d_b">{echo $hotProduct->firstVariant->toCurrency('Price', $NextCSId)} {$NextCS}</span></div>                               
                                    <div class="{$style.class} buttons"><a class="{$style.identif}" data-varid="{echo $hotProduct->firstVariant->getId()}" data-prodid="{echo $hotProduct->getId()}" href="{shop_url('product/' . $hotProduct->getUrl())}">{$style.message}</a></div>
                                </div>   
                            </div>
                        </div>
                    </li>  
                {/foreach}
            </ul>
        </div>
    </div>
</div>