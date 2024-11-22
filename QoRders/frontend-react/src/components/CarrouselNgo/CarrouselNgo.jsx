import React, { useState, useEffect } from 'react';
import { Carousel } from 'primereact/carousel';
import { Button } from 'primereact/button';
import { Tag } from 'primereact/tag';
import '../CarrouselNgo/CarrouselNgo.css';

const NgoCarousel = ({ ngos }) => {

    const ngoTemplate = (ngo) => {
        return (
            <div className="border-1 surface-border border-round m-2 text-center py-5 px-3">
                <div className="mb-3">
                    <img
                        src={ngo.image_url || 'https://via.placeholder.com/150'}
                        alt={ngo.name}
                        className="w-6 shadow-2"
                    />
                </div>
                <div>
                    <h4 className="mb-1">{ngo.name}</h4>
                    <h6 className="mt-0 mb-3">{ngo.country}</h6>
                    <Tag value={ngo.country} severity={getSeverity(ngo.country)}></Tag>
                    <p className="mt-3">{ngo.description}</p>
                </div>
            </div>
        );
    };

    return (
        <div className="card flex justify-content-center">
            <Carousel
                value={ngos}
                numVisible={1}
                numScroll={1}
                orientation="vertical"
                verticalViewPortHeight="500px"
                itemTemplate={ngoTemplate}
            />
        </div>
    );
};

export default NgoCarousel;